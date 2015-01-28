---
author: wrfsh
comments: true
date: 2013-06-29 18:10:57+00:00
layout: post
slug: libusb-porting-tips
title: libusb porting tips
wordpress_id: 195
categories:
- UEFI
---

From [http://www.libusb.org/wiki/libusb-1.0](http://www.libusb.org/wiki/libusb-1.0)


<blockquote>[libusb](http://www.libusb.org/)-1.0 includes a platform abstraction layer allowing for cross-platform compatibility. Linux, Darwin (Mac OS X), Windows, OpenBSD and NetBSD are supported in the latest release.

FreeBSD 8 and above include a FreeBSD-specific reimplementation of the libusb-1.0 API, so your applications will probably work there too. The source code for this library can be found [​here](http://svn.freebsd.org/viewvc/base/head/lib/libusb/).

If you are interested in porting to other platforms, the [PORTING](http://git.libusb.org/?p=libusb.git;a=blob;f=PORTING;h=7070784d04761562e38208d9d2fa4c2460eefc30;hb=ab9cd5a7be637f7b793987971a706b1d11c27ded;js=1) file tells you where to start. We are more than happy to help out here, please write to the mailing list with your questions and feedback.</blockquote>


From [PORTING](http://git.libusb.org/?p=libusb.git;a=blob;f=PORTING;h=7070784d04761562e38208d9d2fa4c2460eefc30;hb=ab9cd5a7be637f7b793987971a706b1d11c27ded;js=1):


<blockquote>

> 
> Implementation-wise, the basic idea is that you provide an interface to
> 
> 

> 
> libusb's internal "backend" API, which performs the appropriate operations on
> 
> 

> 
> your target platform.
> 
> 

> 
> 

> 
> In terms of USB I/O, your backend provides functionality to submit
> 
> 

> 
> asynchronous transfers (synchronous transfers are implemented in the higher
> 
> 

> 
> layers, based on the async interface). Your backend must also provide
> 
> 

> 
> functionality to cancel those transfers.
> 
> 

> 
> 

> 
> Your backend must also provide an event handling function to "reap" ongoing
> 
> 

> 
> transfers and process their results.
> 
> 

> 
> 

> 
> The backend must also provide standard functions for other USB operations,
> 
> 

> 
> e.g. setting configuration, obtaining descriptors, etc.
> 
> 

> 
> </blockquote>




Existing libusb ports are found in [libusb/os folder](http://git.libusb.org/?p=libusb.git;a=tree;f=libusb/os;h=1ec9613c0fc4facf6e9217af4130f02387e2b470;hb=7634714aa696175b08016b6f2185a75a2f55a113;js=1)




libusbi.h contains a very well documented interface that should be implemented on a new platform: [usbi_os_backend](http://git.libusb.org/?p=libusb.git;a=blob;f=libusb/libusbi.h;h=3b602d28ca4cae7577bcdcabddccaeb04c0a79cb;hb=7634714aa696175b08016b6f2185a75a2f55a113;js=1#l468)



