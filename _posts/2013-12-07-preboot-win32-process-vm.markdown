---
author: wrfsh
comments: true
date: 2013-12-07 06:08:59+00:00
layout: post
slug: preboot-win32-process-vm
title: Preboot Win32 process VM
wordpress_id: 286
tags:
- preboot
---

[http://en.wikipedia.org/wiki/Virtual_machine](http://en.wikipedia.org/wiki/Virtual_machine):


<blockquote>A process VM, sometimes called an _application virtual machine_, or _Managed Runtime Environment_ (MRE), runs as a normal application inside a host OS and supports a single process. It is created when that process is started and destroyed when it exits. Its purpose is to provide a [platform](http://en.wikipedia.org/wiki/System_platform)-independent programming environment that abstracts away details of the underlying hardware or operating system, and allows a program to execute in the same way on any platform.</blockquote>


Process VM эмулирует окружение для иденственного процесса. Эмуляция заключается в основном в реализации ABI платформы и стоящего за ним рантайма. Под ABI в данном случае подразумеваются как правило механизм и реализация подобия системных вызовов платформы. Если хостовая [ISA](http://en.wikipedia.org/wiki/Industry_Standard_Architecture) отличается от той, для которой собран таргет, то тогда эмуляция включает в себя и бинарную трансляцию target ISA - host ISA. Референсной реализацией считается [FX!32](http://en.wikipedia.org/wiki/FX%2132)

Если ближе к пребуту, то скоуп такой: на входе имеем win32 PE/PE+ dll однопоточный модуль, который слинкован с родным MS CRT и тянет ряд платформенных ABI зависимостей, как правило в форме импортов kernel32 / ntdll. ISA таргета и хоста совпадают. Помимо загрузки, релокации и разрешения импортов PE laundry list полноценной реализации окружения и ABI примерно такой:



	
  * Куча процесса (kernel32!HeapXXX). Как показала практика тут полезна отдельная куча чтобы не лезть в приватные структуры данных хостовой кучи и иметь возможность отделить аллокации таргета от хоста и трассировать их для отладки.

	
  * Контейнер виртуальной файловой системы процесса для подгрузки модулей по имени, загрузки UI ресурсов, etc.

	
  * TLS, FLS, переменные окружения, настройки кодовой страницы для конвертации строк, - все в контексте таргета.

	
  * Манагмент дополнительных загружаемых библиотек таргета(kernel32!LoadLibrary).

	
  * Динамическое связывание с импортами вызова VM монитора, если процесс знает о его существовании. В нашем случае знает и должен знать во избежании импортов GDI для рисования UI.

	
  * Реализация второстепенных системных вызовов типа записи на консоль, остановки процесса и т.п.


При переходе от однопоточного к многопоточному таргету появляется CreateThread и примитивы синхронизации, и все это возможно реализовать, правда гораздо дороже чем все описанное выше.

Однако до CreateThread существует другой "Nice to have" - поддержка таргетов, состоящий из нескольких модулей. Например поддержка таргета, который линкуется с Qt динамически, а не статически. Проблема с такими таргетами в том, что в отличии от импортов, являющихся часть эмулируемого ABI, VMM ничего не знает о qt.dll и должен опираться на какую-то абстракцию файловой системы для их загрузки и связывания.

Общий поинт в том, что рассматривая пребут на определенном уровне как win32 process VM можно получить четкую модель реализации, которая сама по себе является портируемой на другие реализации пребута (в частности Win32 эмуляцию).
