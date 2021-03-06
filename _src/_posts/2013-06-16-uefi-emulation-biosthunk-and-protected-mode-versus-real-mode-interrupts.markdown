---
author: wrfsh
comments: true
date: 2013-06-16 13:31:38+00:00
layout: post
slug: uefi-emulation-biosthunk-and-protected-mode-versus-real-mode-interrupts
title: '[UEFI Emulation] BiosThunk and protected mode versus real mode interrupts'
wordpress_id: 154
tags:
- preboot
- UEFI
---

DuetPkg для реализации доступа к жесткому диску предоставляет драйвера IDE/SATA/AHCI. Я не хочу опираться на них, потому что мне нужно в итоге вернутся в реальный режим для загрузки хостовой ОС, а драйвера портят картину мира для биоса. Выход - опираться на INT 13h. Но тут встает проблема с прерываниями.

Как работает доставка прерываний в Legacy режиме:



	
  * Железо генерирует прерывание используя линию IRQ

	
  * Intel 8259A программируемый контроллер прерываний содержит маппинг IRQ -> Software interrupt line. Прерывание от железа маппируется на софтверное прерывание процессора. Типичный маппинг это IRQ 0h - 7h -> INT 8h - Fh и IRQ 8h - Fh -> INT 70h - 77h.

	
  * Типично для режима совместимости первый жесткий диск использует IRQ 14, которая маппируется на INT 76h. В результате когда жесткий диск хочет сообщить например о завершении запроса на чтение, то он ассертит IRQ 14, что приводит к софтверному прерыванию 76h. Процессор выполняет софтверный обработчик, навешанный на это прерывание.


Как процессор определяет где находится обработчик прерывания 76h? Здесь все зависит от режима процессора:

В реальном режиме 8086 по линейному адресу 0x0 содержится таблица указателей на обработчики прерываний. Каждый элемент длинной 4 байта и содержит segment:offset указатель на 16-ти битный код обработчика. BIOS инициализирует эту таблицу указателями на обработчики при старте машины. Процессор просто достает 4 байта по смещению 0x76 * 0x4, интерпретирует это как segment:offset указатель и выполняет icall туда.

В защищенном режиме все устроено сложнее. Вместо таблицы указателей с известным оффсетом процессор требует от системного программного обеспечения проинициализировать регистр IDTR, в котором должен быть адрес на описание дескрипторов IDT. IDT похож на GDT в том плане, что в нем содержится 4 байтовый линейный адрес на начало таблицы обработчиков прерываний и ее размер. Сама таблица содержит структуры дескрипторов обработчиков прерываний. Их структуру я объяснять не буду, подробнее можно почитать здесь: [http://wiki.osdev.org/IDT](http://wiki.osdev.org/IDT). Суть в том, что в защищенном режиме процессор использует (установленное софтом) значение регистра IDTR для поиска указателя на процедуру - обработчик прерывания.

В чем проблема?

Наше окружение на базе UEFI работает в защищенном режиме, а это значит что оно должно предоставлять IDT. Для чтения диска мы хотим опираться на BIOS, но BIOS работает в реальном режиме, в котором процессор ничего не знает про IDTR и хочет простую таблицу указателей на 16-ти битный код. Когда мы вовращаемся из защищенного режима в реальный, то все будет работать нормально, потому что обработчики BIOSа окажутся на месте. Что делать когда мы работаем в защищенном режиме? Прерывания доставляются асинхронно и BIOS не будет о них знать, если мы не будем их форвардить. Вопрос, нужно ли из форвардить или нет? DuetPkg этого не делает, но это ни о чем не говорит.

С DuetPkg в этом плане еще хуже. Он использует механизм BiosThunk для реализации EFI_GRAPHICS_OUTPUT_PROTOCOL через ISR 10h биоса: [BiosVideoThunkDxe](http://sourceforge.net/p/edk2/code/HEAD/tree/trunk/edk2/DuetPkg/BiosVideoThunkDxe). Что именно там происходит я описывать не буду - главное то, что код вектора 10h исполняется с выключенными прерываниями. Драйвер возвращается в реальный режим, но при этом весь код, выполняющийся там, выполняется с выключенными прерываниями. Вместо инструкции int драйвер напрямую вызывает код обработчика по указателю. Это значит, что использовать такой механизм для вызова INT 13h нельзя, потому что INT 13h ожидает от диска ответного прерывания по окончанию запроса, с таймаутом. До получения такого ответа он не возвращается, а по истечению таймаута возвращается с ошибкой. Даже если в защищенном режиме реализован форвардинг прерываний в BIOS, то он сработает слишком поздно - когда int 13h уже вернулся, потому что прерывания от диска не было. Clover, как оказалось, своим драйвером диска поверх INT 13h не пользуется.

Почему Duet так делает? Потому что во-первых у него есть драйвера дисков, во-вторых он не хочет пропустить прерывания когда делает thunk в 16-ти битный код и в третьих потому что 10h прерывания не нужны для работы. Проблема есть, но пока она роли не играет. Если мы уходим в реальный режим "насовсем", т.е. чтобы загрузить хостовую ОС, то нам не нужен thunk. Проблема будет, когда мы захотим прочитать с диска во время работы. Решить это можно грубо, включив таки прерывания во время thunk-а и перенаправив их в обработчики биоса. Тогда Duet может потерять несколько прерываний. В крайнем случае придется мутить что-то страшное наподобие редиректора прерываний в оба режима.
