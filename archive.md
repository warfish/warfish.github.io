---
layout: default
title: Archive
---

<div class="highlight">
{% for post in site.posts %}
    <div>
    <h2 class="post-title"><a href="{{ post.url }}">{{ post.title }}</a></h2>
    <time class="post-date">{{ post.date | date_to_string }}</time>
    </div>
{% endfor %}
</div>
