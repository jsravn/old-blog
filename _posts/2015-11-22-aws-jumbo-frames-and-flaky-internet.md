---
layout: post
title: AWS jumbo frames and flaky downloads from the internet
---

Every now and then a bit of networking knowledge comes in handy.

## Jenkins builds

We build our projects across Jenkins slaves running on AWS nodes. A
few of our builds depend on downloading libraries from external
sites. The nodes themselves get updated with puppet, which includes
hitting the fedora rpm servers.

## Random timeouts

We first started running into problems with the puppet
update. Occasionally it would just hang and timeout during rpm updates
and installs.

Similarly, some of our builds would also time out when trying to
connect to the internet.

    Errno::ETIMEDOUT: Connection timed out - connect(2) for "api.rubygems.org" port 443

It all worked fine from the local development network.

## Reproducing it via curl

The timeouts occurred most commonly on a fedora repo update. I tried
curling the repo mirror directly a few times on the Jenkins
slaves. After running this a few times, it showed that our downloads
would hang whenever retrieving from `ftp.icm.edu.pl`. That explains
the flakiness at least (most of the backend mirrors were fine, just
that one caused TCP connections to hang).

Hitting that url from a local workstation worked fine.

Enabling verbose logging in curl showed that the initial http requests
and responses came through fine. Only when transfering the repo data
file did the curl hang.

    $ curl -vL ftp://ftp.icm.edu.pl/pub/Linux/dist/fedora/linux/updates/22/x86_64/repodata/repomd.xml

## Smells like a black hole

[TCP black holes](https://en.wikipedia.org/wiki/Black_hole_(networking)#PMTUD_black_holes)
happen when networking is misconfigured, which unfortunately is quite
common across the internet. The fact that our connection was able to
send small packets (the http response/request) but not large ones (the
repodata file), pointed to a possible
[MTU](https://en.wikipedia.org/wiki/Maximum_transmission_unit) issue.

When your packets are small enough, having mismatched mtus won't
necessarily cause problems right away because each packet is smaller
than the smallest mtu. It's only when one side tries to send an mtu
larger than a router can handle that things start to fail by hanging
silently. Which seemed to match the symptoms I was seeing.

Incidentally, this is also why network admins shouldn't firewall ICMP
indiscriminately as it will break
[path mtu discovery](https://en.wikipedia.org/wiki/Path_MTU_Discovery),
the protocol used to detect mismatched mtus across a
route. Unfortunately, this is very commonly done.

### AWS Jumbo Frames

EC2 in AWS enables jumbo frames. This means our network adapters get
an mtu of 9001. The advantage of this is greater bandwidth across the
network. The
[AWS networking guide](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/network_mtu.html)
has more details.

How about when your EC2 node wants to go out to the internet, where
most things are using an mtu of 1500? Well in theory, the AWS internet
gateway should handle this by clamping the mtu to 1500 via pmtud. I
can see this with the linux utility `tracepath`, where `10.5.5.1` is
the gateway.

    $ tracepath bbc.co.uk
    1?: [LOCALHOST]                   pmtu 9001
    1:  10.5.5.1                      pmtu 1500
    2:  ...

This looked all good to me, but didn't account for why
`ftp.icm.edu.pl` would hang.

### Smoking gun - mss

`tcpdump` to the rescue. Let's see what happens when I retrieve a
file, filtering on the tcp negotiation.

    15:47:34.543000 IP ip-10-5-5-193.internal.48888 > SunSITE.icm.edu.pl.http: Flags [S], seq 1455779260, win 17922, options [mss 8961,sackOK,TS val 3419577942 ecr 0,nop,wscale 9], length 0

    15:47:34.590656 IP SunSITE.icm.edu.pl.http > ip-10-5-5-193.internal.48888: Flags [S.], seq 321729025, ack 1455779261, win 19316, options [mss 9670,sackOK,TS val 908871769 ecr 3419577942,nop,wscale 9], length 0

Check out the
[mss](https://en.wikipedia.org/wiki/Maximum_segment_size)! The remote
site uses 9670 (for an mtu of 10k) and our amazon node uses 8961 (for
an mtu of 9001). TCP will pick the smallest, which is 8961, and try to
use that for all packet sizes. But how is that going to work when
pretty much all routers on the 'net use a 1500 mtu?

To confirm that it's mss causing the problem, I forced the local mtu
to 1500.

    ip link set dev eth0 mtu 1500

And the curl command started working! `tcpdump` showed the local mss
as 1460, which ensures the remote end will send us the right size
packets.

### Conclusion

Since tracepath is working locally, I assume this is due to some
misconfiguration on the route from `icm.edu.pl` to my AWS host, making
path mtu not work, and so it tries sending a 9001 byte packet. Forcing
my node to use a 1500 mtu fixes it, as the mss will be correctly
negotiated.

If your AWS node will send packets to the internet via a gateway,
ensure you change the mtu to 1500 on its network interface. It's also
a good idea to
[open icmp type 3](http://docs.aws.amazon.com/redshift/latest/mgmt/connecting-drop-issues.html#configure-custom-icmp)
to allow ptmud to work.
