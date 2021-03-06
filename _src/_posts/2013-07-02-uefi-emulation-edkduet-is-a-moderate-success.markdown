---
author: wrfsh
comments: true
date: 2013-07-02 16:11:23+00:00
layout: post
slug: uefi-emulation-edkduet-is-a-moderate-success
title: '[UEFI Emulation] EDK/Duet is a moderate success'
wordpress_id: 201
tags:
- BIOS
- UEFI
---

Прототипирование UEFI эмуляции на базе EDK/Duet можно считать законченным. Я считаю результат умеренным успехом. Успехом потому что такой подход действительно позволяет поставить знак равенства между Legacy BIOS и UEFI системами на том уровне поддержки аппаратуры, что нам нужен. А умеренным потому что, несмотря на знак равенства, возможности самого UEFI, будь то native или эмуляция, оставляют за нами массу прикладной работы по поддержке локализации, ввода национальных символов и двух факторной авторизации. Глупо было ожидать обратного. :)

Если сконцентрироваться на хорошем, то UEFI, по сравнению с "голым" PBA дает:



	
  * Защиту памяти и полную адресацию. Коррапты памяти раньше происходили тихо и незаметно. Теперь такие баги генерируют GPF.

	
  * Поддержку современных тулчейнов, включая тот, что используется для остального проекта. Использование MSVC 1.52 можно свести к минимуму, а значит и его баги тоже (а они есть).

	
  * Графический фреймбуфер и рендер растровых юникодных шрифтов.

	
  * Работающий USB и PCI стек.

	
  * Достаточный контроль состояния аппаратуры.

	
  * Модульность, взаимозаменяемость драйверов через повсеместную абстракцию протоколами. Это очень важно для эмуляции, потому что дает возможность заменить реализацию например графического дисплея на свою, работающую через BIOS.

	
  * Поддержка source-level отладки.

	
  * Стеки сетевых протоколов.

	
  * libc


Из "умеренного":

	
  * Поддержка ввода национальных символов совсем базовая. Раскладки нужно генерировать самостоятельно. Если для европейских языков все терпимо, то для азиатских и арабских выглядит довольно сложно, хотя и не невозможно.

	
  * Драйвера крипто токенов. Их либо нет, либо они в непонятно каком состоянии в опенсорсных либах, либо нужно начинать говорить с вендорами токенов.

	
  * Нет полноценного GUI фреймворка "из коробки". Есть все необходимые базовые технологические стеки для его реализации/портирования, типа фреймбуфера, драйверов устройств ввода и т.д, но нет самих примитивов, из которых строится GUI.


Если ссумировать, то UEFI предоставляет всю базу, чтобы реализовать прикладные задачи, но не больше этого. Реализовать все остальное можно используя нормальный компилятор, отладчик, защиту памяти, снятие множества ограничений по ресурсам и т.д. EDK/Duet выравнивает BIOS до этого же уровня, что экономит наверное год работы и дает унифицирование платформы на поддерживаемых аппаратных конфигурациях. Но при этом все, что выходит за рамки базовой платформы, нужно делать/портировать почти самостоятельно, и, хочу еще раз подчеркнуть, это касается UEFI в целом, а не только его эмуляции. Приятное исключение это рендер шрифтов :)
