---
author: wrfsh
comments: true
date: 2013-09-30 14:51:56+00:00
layout: post
slug: doom-uefi-day-1
title: '[DOOM-UEFI] Day 1'
wordpress_id: 231
categories:
- doom-uefi
---

Я решил портировать [doom](http://en.wikipedia.org/wiki/Doom_(video_game)) в пребут на уефай, just for fun.

Отличная статья для ознакомления с архитектурой рендера: [http://fabiensanglard.net/doomIphone/doomClassicRenderer.php](http://fabiensanglard.net/doomIphone/doomClassicRenderer.php)

Репозиторий оригинального бранча на гитхабе: [https://github.com/id-Software/DOOM](https://github.com/id-Software/DOOM)

После беглого просмотра исходников:



	
  * Рендер портировать скорее всего будет просто. Он софтверный с блитом в окно.

	
  * Звук не в скоупе, нет драйверов.

	
  * Мультиплеер тоже не в скоупе.

	
  * Для инпута нужно решить проблему с получением скан кодов из EFI_SIMPLE_TEXT_INPUT.

	
  * Нужна файловая система для подгрузки pk файлов.


Мой форк тут: [https://github.com/warfish/DOOM](https://github.com/warfish/DOOM)
