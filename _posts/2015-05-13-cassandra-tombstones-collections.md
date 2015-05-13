---
layout: post
title: "Cassandra, lists, and tombstones"
---

We're using Cassandra for some fallback behaviour in my current
project. Whenever a downstream system is successfully hit, we store a
copy of the data locally that we can fall back to in case of
downsystem failure.

During load tests of the fallback behaviour, we starting getting
really long, crazy timeouts on reads. Investigating cassandra logs
revealed many of these:

```
 Scanned over 100000 tombstones; query aborted
```

And a few of these sprinkled in:

```
org.apache.cassandra.db.filter.TombstoneOverwhelmingException
```

Tombstones
==========

A tombstone is cassandra's record of a deletion. Like a typical
distributed database, it stores all changes as immutable events. It
can't simply go back and mutate a record like a relational database
would do. Every time a change occurs a new, immutable event is created
(which is represented as an sstable row and can be further compacted,
flushed, propagated). When a delete occurs of a column or row a
tombstone event is created which is appended, in a temporal sense, to
the events that have occurred so far.

Why is this a problem?
======================

Too many tombstones and cassandra goes kaput. Well, more accurately,
if you scan too many tombstones in a query (100k by default) in later
cassandra versions, it will cause your query to fail. This is a safe
guard to prevent against OOM and poor performance. It also implies you
should be monitoring tombstone counts (either via the mbeans or
cassandra warnings about tombstone thresholds).

Tombstones are treated specially by cassandra to guard against
netsplits and prevent deleted data from resurrecting. Unfortunately
it's a leaky abstraction, and tombstones tend to rear their ugly head
if you use Cassandra in particular ways.

The default grace period is 10 days for tombstones, so compaction
won't remove them until then. You can lower the grace period, but keep
in mind repairs need to happen more frequently than the grace period
to prevent data inconsistencies (as repairs ensure your deletes are
replicated correctly).

sstable2json
============

Cassandra has a useful utility for getting a representation of the
actual sstables. In later cassandra versions this is located in
`/usr/share/cassandra/tools/bin/sstable2json`. I advise using the
[source](https://github.com/apache/cassandra/blob/trunk/src/java/org/apache/cassandra/tools/SSTableExport.java)
as reference for its output.

We can use this to see what was going wrong in our case.

Lists
=====

Cassandra supports a list column type. Let's see what an sstable for a
list looks like. Create a table with a list type and insert some data:

    cqlsh> create keyspace james with replication = { 'class': 'SimpleStrategy', 'replication_factor': 1 };
    cqlsh> use james;
    cqlsh:james> create table flights (id text primary key, destinations list<text>);
    cqlsh:james> insert into flights (id, destinations) values ('BA1234', ['ORD', 'LHR']);

Then flush the data to disk:

    $ nodetool flush
    $ ls /var/lib/cassandra/data/james
    james-flights-ka-1-CompressionInfo.db
    james-flights-ka-1-Data.db
    james-flights-ka-1-Digest.sha1
    james-flights-ka-1-Filter.db
    james-flights-ka-1-Index.db
    james-flights-ka-1-Statistics.db
    james-flights-ka-1-Summary.db
    james-flights-ka-1-TOC.txt

And dump the sstable:

```
$ sudo /usr/share/cassandra/tools/bin/sstable2json james-flights-ka-1-Data.db
```

And voila:

{% highlight json %}
    {
        "key": "BA1234",
        "cells": [
            [
                "",
                "",
                1431547185462964
            ],
            [
                "destinations:_",
                "destinations:!",
                1431547185462963,
                "t",
                1431547185
            ],
            [
                "destinations:9a31d0b0f9aa11e4828b2f4261da0d90",
                "4f5244",
                1431547185462964
            ],
            [
                "destinations:9a31d0b1f9aa11e4828b2f4261da0d90",
                "4c4852",
                1431547185462964
            ]
        ]
    }
{% endhighlight %}

We see the key, `BA1234`, then an empty column with the sstable row
timestamp. The last two columns represent our list. `4f5244` is `ORD`
in hex, and likewise for LHR.

But what's that weird column with a `"t"`? That, my friends, is a
tombstone range deleting the list columns.

But wait a sec, isn't this a fresh new insert? Well yeah, it is. But
it's also the same sstable row you would get if you were replacing a
previous record for 'BA1234'. Cassandra is optimizing for writes here,
as it tends to do. It could be smarter and check if the list has
changed, but that would require reconstructing all prior sstables for
'BA1234' (a read). So it just always issues a delete and avoids the
read.

The danger of writing collections willy nilly
=============================================

And so we hit the crux of our issue. On every downstream call we were
inserting a row of data that included a list column. Even if the data
didn't change at all. Every request added a new tombstone to the
sstables and kaboom.

There are a few ways to tackle this. We opted to store our object
simply as its json representation rather than breaking it into a set
of column types. If we really needed the list, we would probably have
had to turn it into a [separate column family with compound key](http://docs.datastax.com/en/cql/3.1/cql/ddl/ddl_compound_keys_c.html).
