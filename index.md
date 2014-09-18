---
layout: default
title: James Ravn's Web Base
---

Welcome to my little corner on the web.

Thoughts
========

<ul class="posts">
{% for post in site.posts %}
  <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ post.url }}">{{ post.title }}</a></li>
{% endfor %}
</ul>


Open source contributions
=========================

- [circle 3.1 mccp](/random/mccp/)
- [fuhquake](http://ezquake.sourceforge.net/docs/?rtc)
- [crawl](https://gitorious.org/crawl/crawl/commits)
- [the original omnibar](https://addons.mozilla.org/en-US/firefox/addon/autocomplete-manager/)
- [darkpawns](https://github.com/rparet/darkpawns)
- [xmpp-uri](https://github.com/jsravn/xmpp-uri)
- [sovereign](https://github.com/al3x/sovereign)
- [jbehave](http://jbehave.org/)
