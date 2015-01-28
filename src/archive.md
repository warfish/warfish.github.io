---
layout: page
---
<h2>Post archive:</h2>
<p></p>
<ul class="post-list">
    {% for post in site.posts %}
    <li>
    <h3 class="post-title"><a href="{{ post.url }}">{{ post.title }}</a></h3>
    <time class="post-date">{{ post.date | date_to_string }}</time>
    </li>
    {% endfor %}
</ul>
