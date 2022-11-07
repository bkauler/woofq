2020-01-31
----------
in woofQ, script puppy/7-build-puppy-cd will delete rootfs-complete/usr/share/doc/easy
and rename rootfs-complete/usr/share/doc/puppy to easy.

So, the html home, welcome and help html pages are in the location that
/usr/sbin/quicksetup expects them.

These html pages replace EasyOS pages with those for EasyPup.
