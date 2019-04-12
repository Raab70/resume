{% extends "section.md" %}

{% block body %}
<table class="table table-hover">
{% for talk in items %}
<tr>
  <td class='col-md-3'>{{ talk.date }}</td>
  <td>
    {{ talk.title }}
  </td>
  <td>
    {{ talk.loc }}
  </td>
</tr>
{% endfor %}
</table>
{% endblock body %}
