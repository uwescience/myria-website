---
layout: default
title: "Myria Research"
id: "projects"
---

## {{ page.title }}

Myria is a new stack for big data management and analytics:

* Myria is a new big data management and analytics system
* It is available open source [Myria stack on Github] (https://github.com/uwescience/myria-stack)
* It runs in shared-nothing clusters (Amazon EC2)
* Myria is also a service. Check our [demo service] (http://demo.myria.cs.washington.edu).
  If you are at UW and would like to try our production service, send an email to myria-users@cs.washington.edu

Myria is developed by the UW database group and eScience Institute.

On this page, we describe the specific research contributions
that we are making through the Myria project.

<hr>


<div class="container projectlist">

  {% for post in site.categories.projects limit:50 %}

  {% include project.shtml %}

  {% endfor %}
</div>
