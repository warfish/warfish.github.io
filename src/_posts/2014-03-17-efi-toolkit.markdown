---
author: wrfsh
comments: true
date: 2014-03-17 06:32:17+00:00
layout: post
slug: efi-toolkit
title: EFI toolkit
wordpress_id: 379
tags:
- UEFI
---

До того как Intel открыл TianoCore и вокруг него развился EDK был EFI toolkit:
[http://sourceforge.net/p/efi-toolkit/code/HEAD/tree/trunk/efi-toolkit/](http://sourceforge.net/p/efi-toolkit/code/HEAD/tree/trunk/efi-toolkit/)

Гораздо более легковесный проект чем EDK, содержит EFI спеку в хедерах, порты libc, libm, libsocket, libz, реализацию TCP/IP стека и тонкую convinience wrapper library в виде libefi. Причем порт libc, в отличии от EDK, зависим только от спеки и libefi. В общем то что мне и нужно было всегда, но есть минусы:



	
  1. С появлением EDK на проект забили, последние коммиты датируются концом 2006 года. Версия спецификации в хедерах 1.3.что-то.

	
  2. Нет GNU мейкфайлов, только nmake.


Я сделал себе бранч: [https://github.com/warfish/uefi-toolkit
](https://github.com/warfish/uefi-toolkit)Пока планирую сделать сборку под юниксы, стряхнуть пыль и обновить хедера до UEFI spec 2.4.
