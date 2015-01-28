---
author: wrfsh
comments: true
date: 2013-05-16 14:16:50+00:00
layout: post
slug: dell-optiplex-and-buggy-bioses
title: Dell optiplex and buggy BIOSes
wordpress_id: 52
tags:
- BIOS
- preboot
---

Сегодня прототип отказался загружаться на тестовой машине Dell optiplex 790. Судя по гуглу, нам безумно повезло с тестовым железом. [GRUB](http://www.gnu.org/software/grub/) содержит такую кашу воркэраундов вокруг деллового биоса, что волосы встают дыбом.

Проект grub4dos, который пытается выполнить очень близкую нам вещь - загрузится из линукса через [kexec](http://en.wikipedia.org/wiki/Kexec) и стартовать другую ОС - так же испытывает много боли:

[http://reboot.pro/topic/10201-grub4dos-and-dell-optiplex-cant-boot/](http://reboot.pro/topic/10201-grub4dos-and-dell-optiplex-cant-boot/)

[http://reboot.pro/topic/12449-funny-dell-bios-and-how-to-determine-number-of-hd-connected/](http://reboot.pro/topic/12449-funny-dell-bios-and-how-to-determine-number-of-hd-connected/)

[http://www.911cd.net/forums/lofiversion/index.php/t20864.html](http://www.911cd.net/forums/lofiversion/index.php/t20864.html)



Выводы:

1. Нужно попробовать посмотреть и позапускать grub4dos (кажется через него работает guardian edge).

2. Нужно попробовать другое, не делловое, железо.


