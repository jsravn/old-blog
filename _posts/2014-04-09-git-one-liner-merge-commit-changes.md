---
layout: post
title: "Git one liner to list directories changed by a merge or regular commit"
---

I've been working on a CI trigger that runs particular jobs depending
on which project changed. The tricky aspect is we have a single git
repository. So given a commit hash, we want to determine which
projects to trigger builds for.

This is easy for a commit with a single parent - git diff-tree can
show what changed simply by passing that commit. A merge commit is a
little more work. Here is the one liner that will work for both
regular and merge commits:

{% highlight bash %}
git rev-list $commit^1..$commit |
    git diff-tree --stdin --no-commit-id --name-only | sort | uniq
{% endhighlight %}

If the root of your git repo looks like this:

{% highlight bash %}
> ls
project1 project2 project3
{% endhighlight %}

You'll get an output like:

{% highlight bash %}
project2
project3
{% endhighlight %}

When project2 and project3 were changed by the `$commit`.

`rev-list $commit^1..$commit` produces all commits reachable by
`$commit` excluding those reachable by its first parent. So for a
regular commit, you get the changes introduced by that commit
only. For a merge commit, you get all the changes that were merged in
from the other branch.

You can customize the list displayed by passing additional arguments
to `git diff-tree`. For instance, `-r` will recursively list all files
changed.
