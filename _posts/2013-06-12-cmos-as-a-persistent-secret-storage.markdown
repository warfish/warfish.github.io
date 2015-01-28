---
author: wrfsh
comments: true
date: 2013-06-12 14:54:30+00:00
layout: post
slug: cmos-as-a-persistent-secret-storage
title: CMOS as a persistent secret storage
wordpress_id: 112
categories:
- BIOS
- unrealistic ideas
---

Чтобы PBA работало с перезагрузкой, нужно сохранить где-то секрет. Секрет можно разбить на две части - данные и ключ шифрования. В таком случае данные можно положить на диск, а вот куда деть ключ, так чтобы он пережил перезагрузку и его было легко стереть.

На UEFI есть [NVRAM](http://en.wikipedia.org/wiki/Non-volatile_random-access_memory), а вот на BIOS есть [CMOS](http://en.wikipedia.org/wiki/CMOS). Он гораздо меньше, 512 байт, но мне нужно всего 16. Можно поэкспериментировать с хранением секрета в этой памяти в случае, если без перезагрузки жить не получится. Основная проблема с таким подходом пожалуй в том, что формат данных, хранимых в CMOS, плохо стандартизирован. Не понятно где свободное место, а где нужные биосу данные.



Код чтения и записи CMOS в Linux: [http://lxr.linux.no/linux+v3.9.5/drivers/char/nvram.c](http://lxr.linux.no/linux+v3.9.5/drivers/char/nvram.c)

CMOS memory map: [http://www.bioscentral.com/misc/cmosmap.htm#](http://www.bioscentral.com/misc/cmosmap.htm#)

OSDev article: [http://wiki.osdev.org/CMOS](http://wiki.osdev.org/CMOS)
