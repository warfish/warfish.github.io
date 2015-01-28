---
author: wrfsh
comments: true
date: 2013-10-03 16:54:09+00:00
layout: post
slug: doom-uefi-development-environment
title: '[DOOM-UEFI] Development environment'
wordpress_id: 239
categories:
- doom-uefi
---

[![Screen Shot 2013-10-03 at 11.47.33 PM](http://wrfsh.files.wordpress.com/2013/10/screen-shot-2013-10-03-at-11-47-33-pm.png?w=300)](http://wrfsh.files.wordpress.com/2013/10/screen-shot-2013-10-03-at-11-47-33-pm.png)

Qemu запущен с кастомной прошивкой из EDK - OVMF. У этого эмулятора есть убойная фича (вообще их много) - способность задавать в качестве диска папку на хостовой файловой системе.

Qemu грузится с OVMF, запускается уефайный шелл, fs0 показывает на папку на хосте, где лежит doom.efi. Красота.
