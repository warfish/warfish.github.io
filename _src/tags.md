---
layout: page
---
<p>
  {% for tag in site.tags %}
  <a style="font-size: {{ tag | last | size | times: 100 | divided_by: site.tags.size | plus: 100 }}%" href="{{ site.baseurl }}{{ tag | first }}/">{{ tag | first }}</a>
  {% endfor %}
</p>
