---
author: wrfsh
comments: true
date: 2013-06-28 15:33:05+00:00
layout: post
slug: opensc-uefi
title: OpenSC / UEFI
wordpress_id: 191
categories:
- crypto
- UEFI
---

Чтобы портировать связку libopensc/libopenct нужно:



	
  1. Затащить StdLib. В EDK есть реализация: [http://sourceforge.net/p/tianocore/edk2/ci/master/tree/StdLib/](http://sourceforge.net/p/tianocore/edk2/ci/master/tree/StdLib/). Есть небольшое неудобство - ванильная реализация StdLib в EDK линкуется только с UEFI_APPLICATION (а не DXE_DRIVER). Поэтому PBA _везде_ должен быть аппликейшеном. Либо можно распилить StdLib на части и копилировать сишники. Тоже вариант.

	
  2. Написать реализацию функций ifd_sysdep_usb_* в OpenCT. Вот пример порта на [libusb](http://www.libusb.org/)/Linux: [https://github.com/OpenSC/openct/blob/master/src/ifd/sys-linux.c](https://github.com/OpenSC/openct/blob/master/src/ifd/sys-linux.c).

	
  3. Вытравить зависимости от файловой системы в вспомогательном коде OpenCT. Например у него есть конфиг, который он при инициализации парсит из файла и т.д.

	
  4. Выкинуть все "ненужное". Например общение с токенами по серийному порту.


Вместо пункта 2 (порт ifd_sysdep_usb_*) можно подойти к вопросу фундаментальнее - портировать libusb. Эта либа своего рода стандартный API доступа к USB устройствам на линуксе. На нее портировано много всего, включая OpenCT. Если портануть ее, то это дает гибкость, можно не портировать USB стек второй раз в какой-нибудь другой либе. Но это медленнее, потому что libusb больше.
