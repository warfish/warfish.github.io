---
author: wrfsh
comments: true
date: 2013-10-07 15:43:55+00:00
layout: post
slug: uefi-doom-how-not-to-write-portable-code
title: '[UEFI-DOOM] How not to write portable code'
wordpress_id: 252
tags:
- doom-uefi
---

Структура текстурного патча из сурсов дума. Подразумевается что эти структуры хранятся в ресурсном образе as is, код подгружает их читая sizeof(maptexture_t) из файла:


<blockquote>struct maptexture_t
{
char name[8];
boolean masked;
short width;
short height;
void** obsolete;
patch_t patches[1];
};</blockquote>


Естественно собираясь для 64-х битного уефая размер этой структуры едет сразу по нескольким полям.
