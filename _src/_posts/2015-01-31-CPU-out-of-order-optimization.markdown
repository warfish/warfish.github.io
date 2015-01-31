---
author: wrfsh
comments: true
date: 2015-01-31
layout: post
title: CPU out-of-order performance
tags:
    - hardware
---

Начиная с [P6](http://en.wikipedia.org/wiki/P6_%28microarchitecture%29) интел реализует out-of-order спекулятивную суперскалярную микроархитектуру. Это означает, в общих чертах, что в ядре работают несколько конвееров и оно умеет наружать их микрокодом инструкций не обязательно в том порядке, в котором они идут в машинном коде если результат вычислений в пределах instruction window не меняется. 

На практике это означает, что если внутри ограниченной последовательности инструкций последующая инструкция не зависит от результата вычислений предыдущей, то ее можно начать выполнять уже сейчас, оптимально на другом конвеере:

<p>
<a href="http://www.renesas.com/media/products/mpumcu/rx/getting_started/feature/rxfamily_feature01.gif"><img src="http://www.renesas.com/media/products/mpumcu/rx/getting_started/feature/rxfamily_feature01.gif"></img></a>
</p>

Это известная фича, но я решил сделать небольшой бенчмарк. Для этого я сделал 64-х битный уефайный бинарник, который запускается на одном ядре на голом железе и выполняет три теста замеряя производительность с помощью сериализующей RDTSCP:
<ul>
<li>Первый тест считает оверхед, наложенный работой с RDTSCP - контрольная группа.
{% highlight NASM %}
test0:
    ; Save-disable interrupts
    pushf
    cli

    ; Save starting tsc in rbx (wasting some overhead cycles)
    rdtscp              
    shl     rdx, 32     
    add     rdx, rax    
    mov     rbx, rdx    
    
    ; Collect end tsc
    rdtscp              
    shl     rdx, 32     
    add     rdx, rax
    mov     rax, rdx
    sub     rax, rbx

    ; Restore interrupts and return
    popf
    ret
{% endhighlight %}
</li>

<li>
Второй тест пытается сложить шесть 64-х битных чисел со стека и сохранить результат по указателю на стеке. При этом в коде сложения каждая следующая инструкция зависит от результатов предыдущей
{% highlight NASM %}
test1:
    push    rbp
    mov     rbp, rsp

    ; Save-disable interrupts
    pushf
    cli

    ; Save starting tsc in rbx (wasting some overhead cycles)
    rdtscp              
    shl     rdx, 32     
    add     rdx, rax    
    mov     rbx, rdx    
    
    ; Add numbers
    mov     rdx, [rbp + 0x10]
    mov     rax, rdx            
    mov     rdx, [rbp + 0x18]
    add     rax, rdx            
    mov     rdx, [rbp + 0x20]
    add     rax, rdx            
    mov     rdx, [rbp + 0x28]
    add     rax, rdx            
    mov     rdx, [rbp + 0x30]
    add     rax, rdx            
    mov     rdx, [rbp + 0x38]
    add     rax, rdx            
    
    ; Store
    mov     rdx, [rbp + 0x10]
    mov     [rdx], rax

    ; Collect end tsc
    rdtscp              
    shl     rdx, 32    
    add     rdx, rax
    mov     rax, rdx
    sub     rax, rbx

    ; Restore interrupts and return
    popf
    pop     rbp
    ret
{% endhighlight %}
</li>

<li>
Третий тест делает тоже самое что и второй, но в нем я пытался написать максимально дружелюбный к out-of-order код. При этом количество инструкций выполняющих сложение одинаково в обоих тестах
{% highlight NASM %}
test2:
    push    rbp
    mov     rbp, rsp

    ; Save-disable interrupts
    pushf
    cli

    ; Save starting tsc in rbx (wasting some overhead cycles)
    rdtscp              
    shl     rdx, 32     
    add     rdx, rax    
    mov     rbx, rdx    
    
    ; Add numbers
    mov     rdx, [rbp + 0x10]
    mov     rcx, [rbp + 0x18]
    mov     r8,  [rbp + 0x20]
    mov     r9,  [rbp + 0x28]
    mov     r10, [rbp + 0x30]
    mov     r11, [rbp + 0x38]
    add     rdx, rcx
    add     r8, r9
    add     r10, r11
    add     rdx, r8
    add     rdx, r10
    mov     rax, rdx 

    ; Store
    mov     rdx, [rbp + 0x10]
    mov     [rdx], rax

    ; Collect end tsc
    rdtscp              
    shl     rdx, 32     
    add     rdx, rax
    mov     rax, rdx
    sub     rax, rbx

    ; Restore interrupts and return
    popf
    pop     rbp
    ret
{% endhighlight %}
</li>

</ul>

Каждый тест, как я уж сказал, я прогнал 4 раза на голом железе с выключенными прерываниями. Еще я заренее разогревал кеши инструкций верхушки стека предварительным проходом, который не фиксируется:

<ul>
<li>Первый тест, оверхед замеров:
<pre>
0: 36
1: 36
2: 36
3: 36
Mean: 36
</pre>
</li>

<li>Второй тест, пессимизация под out-of-order:
<pre>
0: 154
1: 156
2: 152
3: 144
Mean: 151.5
</pre>
</li>

<li>Третий тест, оптимизация под out-of-order:
<pre>
0: 40
1: 40
2: 40
3: 40
Mean: 40
</pre>
</li>

</ul>

Результаты говорят сами за себя и в общем-то ожидаемые.<br />
Тесты гонялись на Intel(R) Core(TM) i3-3240 CPU @ 3.40GHz
