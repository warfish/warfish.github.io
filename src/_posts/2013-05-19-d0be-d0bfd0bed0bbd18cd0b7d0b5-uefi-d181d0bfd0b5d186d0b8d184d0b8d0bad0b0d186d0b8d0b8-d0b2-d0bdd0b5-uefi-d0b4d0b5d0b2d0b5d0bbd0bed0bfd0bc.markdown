---
author: wrfsh
comments: true
date: 2013-05-19 12:04:03+00:00
layout: post
slug: '%d0%be-%d0%bf%d0%be%d0%bb%d1%8c%d0%b7%d0%b5-uefi-%d1%81%d0%bf%d0%b5%d1%86%d0%b8%d1%84%d0%b8%d0%ba%d0%b0%d1%86%d0%b8%d0%b8-%d0%b2-%d0%bd%d0%b5-uefi-%d0%b4%d0%b5%d0%b2%d0%b5%d0%bb%d0%be%d0%bf%d0%bc'
title: О пользе UEFI спецификации в не-UEFI девелопменте.
wordpress_id: 73
tags:
- preboot
- UEFI
---

Вообще, если абстрагированно взглянуть на UEFI спеку, то можно использовать ее в качестве готовой документации на контракты интерфейсов различных сервисов пребута. Например, посмотрите на относительно простой протокол SIMPLE_TEXT_OUTPUT_PROTOCOL (11.4). Спецификация явно декларирует такие вещи как в каких ситуация и как производится перевод позиции текстового курсора:

Table 90. EFI Cursor Location/Advance Rules (страница 430)

Mnemonic Unicode Description

    
    Null     U+0000  Ignore the character, and do not move the cursor.
    BS       U+0008  If the cursor is not at the left edge of the display, 
                     then move the cursor left one column.
    LF       U+000A  If the cursor is at the bottom of the display, then scroll 
                     the display one row, and do not update the cursor position. 
                     Otherwise, move the cursor down one row.
    CR       U+000D  Move the cursor to the beginning of the current row.
    Other    U+XXXX  Print the character at the current cursor position 
                     and move the cursor right one column. 
                     If this moves the cursor past the right edge of the display, 
                     then the line should wrap to the beginning of the next line. 
                     This is equivalent to inserting a CR and an LF. 
                     Note that if the cursor is at the bottom of the display, 
                     and the line wraps, then the display will be scrolled one line.


На мой взгляд это отличная готовая спецификация контракта на интерфейс сервиса печати на текстовую консоль в пребуте, UEFI или не UEFI.
