---
author: wrfsh
comments: true
date: 2013-06-15 14:51:39+00:00
layout: post
slug: uefi-emulation-dxecore
title: '[UEFI Emulation] DxeCore'
wordpress_id: 144
tags:
- UEFI
---

DxeCore - Ядро UEFI рантайма, стартует сразу после PI (Platform Initialization) стадии. В терминах DuetPkg, где Pi стадия заключается в инициализации пейджинга и idt, сразу после DuetPkg/DxeIpl.

В DxeCore сосредоточено очень много интересного, в том числе аллокаторы страниц и пулов, учет хендлов, публикация протоколов и т.д. Его роль - реализация базового функционала, необходимого в рантайме UEFI. Все остальное по сути врапперы и клиенты этой основы.

Код можно посмотреть здесь: [Dxe](http://sourceforge.net/p/edk2/code/HEAD/tree/trunk/edk2/MdeModulePkg/Core/Dxe)

Удивляет отстутсвие тестов, но может я чего-то не вижу / не знаю.
