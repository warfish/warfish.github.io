---
author: wrfsh
comments: true
date: 2014-03-17 13:33:14+00:00
layout: post
slug: freestanding
title: Freestanding
wordpress_id: 381
---

Какой замечательный у GCC есть флажок:


<blockquote>-ffreestanding
Assert that compilation takes place in a freestanding environment. This implies -fno-builtin. A
freestanding environment is one in which the standard library may not exist, and program startup may not
necessarily be at "main". The most obvious example is an OS kernel. This is equivalent to -fno-hosted.

</blockquote>
