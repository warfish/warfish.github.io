---
author: wrfsh
comments: true
date: 2013-07-20 08:31:19+00:00
layout: post
slug: uefi-quick-ui-toolkit-overview
title: '[UEFI] Quick UI toolkit overview'
wordpress_id: 221
tags:
- UEFI
---

EFI (нативно и эмулируемо) дает интерфейс [GOP](http://wiki.phoenix.com/wiki/index.php/EFI_GRAPHICS_OUTPUT_PROTOCOL), который поддерживает BitBlt и предлагает реализовывать GUI поверх него.  Предполагается, что BitBlt это все что нужно для этого. Я поискал в интернетах открытые и проприетарные GUI тулкиты для EFI, для embedded и для linux framebuffer, потому что последний достаточно близко эмулируется поверх GOP. Вот что удалось откапать.



**C/PEG, PEG+, PEG Pro**

[http://www.swellsoftware.com/products/cpeg.php](http://www.swellsoftware.com/products/cpeg.php)

Проприетарное решение от SwellSoftware, ссылка ведет на C/PEG, рядом лежат PEG+ и PEG Pro, которые стоят дороже, но дают больше функционала. В пдфке стоит поддержка x86 VBE и linux framebuffer. К сожалению evaluation kit они хотят слать физической почтой и требуют указать американский штат, поэтому посмотреть в жизни не удается. Тем не менее решение выглядит интересно, хотя цена на лицензирование только по прямому запросу в отдел продаж.



**FLTK**

[http://www.fltk.org/index.php](http://www.fltk.org/index.php)

Fast Light Tool Kit. Достаточно взрослый и стабильный проект, быстрый, легковесный, умеет рендерить шрифты и содержит достаточно неплохой набор виджетов. Лицензия GPL v2 с небольшими дополнениями, а именно [http://www.fltk.org/COPYING.php](http://www.fltk.org/COPYING.php):


<blockquote>Static linking of applications and widgets to the FLTK library does not constitute a derivative work and does not require the author to provide source code for the application or widget, use the shared FLTK libraries, or link their applications or widgets against a user-supplied version of FLTK.

If you link the application or widget to a modified version of FLTK, then the changes to FLTK must be provided under the terms of the LGPL in sections 1, 2, and 4.</blockquote>


Т.е. позволяет линковаться статически и не требует раскрытия кода клиентского приложения.

Проблема с FLTK в том, что он опирается на Carbon/GDI/X11, что существенно усложняет портирование.



**Microwindows**

[http://www.microwindows.org/](http://www.microwindows.org/)

Еще один распространенный в embedded среде тулкит. Пристально пока не смотрел, но радует вот это утверждение с главной страницы:


<blockquote>All drivers are endian-neutral with only Read/DrawPixel, DrawV/Hline and Blit entry points.</blockquote>


Т.е. реализация опирается на архитектуру графического драйвера, которому нужны DrawPixel, Draw[V/H]Line и Blit. Опять же, пристально не вглядывался, но такой вариант достаточно портируемый. Лицензирован под [MPL](http://www.mozilla.org/MPL/). Архитектуру можно почитать [здесь](http://www.microwindows.org/microwindows_architecture.html), советую обратить внимание на раздел Screen Driver


### 


**Embedded Qt**

[http://qt-project.org/doc/qt-4.8/qt-embedded-linux.html](http://qt-project.org/doc/qt-4.8/qt-embedded-linux.html)

Встраиваемая версия Qt работающая поверх linux framebuffer. Очень интересный вариант. Что такое Qt думаю пояснять не стоит, а вот про то, что такое фреймбуфер можно почитать [здесь](http://tldp.org/HOWTO/Framebuffer-HOWTO/).



**Итого**

Есть еще несколько слишком абстрактных вариантов, типа Tcl\Tk порт, но наиболее интересными мне кажутся варианты с Microwindows и Embedded Qt.
