---
layout: post
title: "Arch Linux on a Thinkpad X220"
---

This is a guide on how I set up Arch/xmonad on my X220. I reviewed the X220 in my
[previous post](/2013/06/26/thinkpad-x220.html).

Install Arch
============

First, of course, do all the usual stuff in the
[Installation Guide](https://wiki.archlinux.org/index.php/Installation_Guide).
The only tricky part is dealing with UEFI.

UEFI Boot
=========

The x220 is a UEFI based bios, so you need to boot your installed system via
UEFI. This is still a somewhat hacky process (at least, compared to traditional
BIOS booting). I used grub and followed the [Grub UEFI
Guide](https://wiki.archlinux.org/index.php/GRUB#UEFI_systems_2).

If you follow the guide, grub efi will be installed to /boot/efi/EFI/arch_grub.
grub_install calls `efibootmgr`, which will fail if you're booting from the
normal USB image.

This is ok since we don't need a boot entry anyways. The Thinkpad bios won't
automatically boot an EFI image unless it's the blessed `bootx64.efi`. So
simply copy `arch_grub/grubx64.efi` to `boot/bootx64.efi`:

{% highlight bash %}
$ mkdir /boot/efi/EFI/boot
$ cp /boot/efi/EFI/arch_grub/grubx64.efi /boot/efi/EFI/boot/bootx64.efi
{% endhighlight %}

Now you should be able to reboot into your Arch install without a problem.
Future runs of grub_install will succeed in adding an arch_grub efi entry but
this can be safely ignored (or deleted, if you prefer).

Power management (Edit: 2014-09-14)
==============================================

I no longer enable any of these things. I get very good battery
performance out of the box (around -10W), and I found these settings
had no impact. My biggest battery drainers are the screen and
chromium, which I can do little about.

Power management with laptop mode tools
---------------------------------------

In the past I always used laptop-mode-tools, but shied away from it in this
build. I wanted to know exactly what I was tweaking and the consequences of it,
rather than just leaving it up to laptop-mode-tools. If you don't want to mess
with files in /etc, I recommend sticking with laptop-mode-tools as a hands-free
power saving service:

{% highlight bash %}
$ pacman -S laptop-mode-tools
$ systemctl enable laptop-mode-tools
$ systemctl start laptop-mode-tools # and we're done!
{% endhighlight %}

You may want to do a quick inspection of the laptop-mode conf files to make
sure it is configured the way you expect. In particular, I'm not comfortable
with the 10 minute potential data loss it defaults to.

Power management the hard way
-----------------------------

Disable nmi_watchdog to reduce wakeups:

{% highlight bash %}
# /etc/sysctl.d/disable_watchdog.conf
kernel.nmi_watchdog = 0
{% endhighlight %}

And enable audio power management:

{% highlight bash %}
# /etc/modprobe.d/audio_power_save.conf
options snd_hda_intel power_save=1
{% endhighlight %}

Finally, set up device power management in a udev rule:

{% highlight bash %}
# /etc/udev/rules.d/power_saving.rules
# Set default backlight to 2 below max (15).
SUBSYSTEM=="backlight", ACTION=="add", KERNEL=="acpi_video0", ATTR{brightness}="13"
# Disable bluetooth completely.
SUBSYSTEM=="rfkill", ATTR{type}=="bluetooth", ATTR{state}="0"
# Disable wake on lan, requires ethtool.
ACTION=="add", SUBSYSTEM=="net", KERNEL=="eth*|enp*" RUN+="/usr/bin/ethtool -s %k wol d"
# Enable scsi link power management.
SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="min_power"
# Enable pci power management.
ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"
# Enable usb power management.
ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control" ATTR{power/control}="auto"
ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend" ATTR{power/autosuspend}="2"
# Enable wireless power management.
ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan0|wlp3s0" RUN+="/usr/sbin/iw dev %k set power_save on"
{% endhighlight %}

Reboot your system and you should be set.

Further power tweaks
--------------------

I purposely avoided the crazy stuff like deep i915 rc6 states since I wanted a
stable system. However, one thing you may want to tweak further are the disk
flush settings.

Increase the flush interval:

{% highlight bash %}
# /etc/sysctl.d/flush_interval.conf
# flush dirty pages every 15 seconds, default is 5.
vm.dirty_writeback_centisecs = 1500
{% endhighlight %}

And add the commit option to your fstab for ext3/ext4 filesystems:

{% highlight bash %}
# /etc/fstab
# sync disk every 15 seconds, default is 5
LABEL=arch / ext4 rw,relatime,data=ordered,commit=15 0 1
{% endhighlight %}

This has the effect of reducing the wakeups of the two background writers -
jbd2 in ext4 and the kernel flushers. The larger these values, the more likely
you are to lose data.

`/proc/sys/vm/laptop_mode` should be left alone unless you have a mechanical
disk drive - in which case, you may be better off using laptop-mode-tools.

A few final system tweaks
=========================

Let's get rid of the anti-social beeping:

{% highlight bash %}
# /etc/modprobe.d/nobeep.conf
blacklist pcspkr
{% endhighlight %}

(Edit: 2014-09-10) Disabling pm_async is no longer necessary.

System services
===============

Since I have an SSD, I want to run fstrim occasionally. Install `cronie` and
add a weekly job for fstrim:

{% highlight bash %}
# /etc/cron.weekly/0fstrim
#!/bin/bash
fstrim -v /
{% endhighlight %}

(Edit: 2014-09-10) I no longer use thermald - I got very little
benefit out of it. But feel free to experiment with it.

The x220 is on ivy bridge and can benefit from the
[Intel Thermal Daemon](https://01.org/linux-thermal-daemon).

{% highlight bash %}
$ git clone https://github.com/01org/thermal_daemon.git
$ cd thermal_daemon
$ ./autogen.sh
$ ./configure prefix=/usr
$ make
$ sudo make install
$ sudo systemctl enable thermald
$ sudo systemctl start thermald
{% endhighlight %}

This uses some intel specific kernel features (such as intel_pstate) to keep the
cpu cores cool under load.

Charge thresholds
-----------------

(Edit: 2014-09-10) I no longer bother with charge thresholds.
My first battery died just after a year (common issue with Lenovo
batteries), so why bother?

Another nice feature are charge thresholds. They can improve the longevity of
the battery, particularly if you spend a lot of time on AC power.  We can set
the thresholds with acpi_call and tpacpi-bat.

{% highlight bash %}
$ yaourt -S acpi_call
$ yaourt -S tpacpi-bat
$ cp /usr/lib/systemd/system/tpacpi-bat.service /etc/systemd/system
$ vim /etc/systemd/system/tpacpi-bat.service # set desired thresholds
$ systemctl start tpacpi-bat
$ systemctl enable tpacpi-bat
{% endhighlight %}

I'm currently using 45/95. It depends a lot on your usage pattern and battery
size.

That's it
=========

And that's it for the system setup. In my next post I'll cover how I set up my
user environment, including xmonad.
