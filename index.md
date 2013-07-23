---
layout: default
title: James Ravn's Web Base
---

News
====

I'm currently seeking employment in the United Kingdom or Southern California.
My wife and I want to move back near family after almost 8 wonderful years in
Chicago.  If interested, please contact me by email.

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
