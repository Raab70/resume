{% extends "section.md" %}

{% block body %}
<table class="table table-hover">
{% for i in items %}
<tr>
    <td class='col-md-3'><strong>{{ i.name }}</strong></td>
  <td><a href='{{ i.url }}'>{{ i.url }}</a></td>
</tr>
<tr>
<td colspan="100%">
<ul>
{% for detail in i.details %}
<li markdown="1">
{{ detail }}
</li>
{% endfor %}
</ul>
</td>
</tr>
{% endfor %}
</table>
{% endblock body %}
