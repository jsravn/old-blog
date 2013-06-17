---
layout: default
title: James Ravn's Web Base
---

Thoughts
========

<ul class="posts">
{% for post in site.posts %}
  <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ post.url }}">{{ post.title }}</a></li>
{% endfor %}
</ul>


Random stuff
============

- [Circle 3.1 MCCP patch](/random/mccp/) - mud client compression protocol version 2 support
- [fuhquake rtc patch](http://ezquake.sourceforge.net/docs/?rtc) - originally for fuhquake, ported to ezquake
