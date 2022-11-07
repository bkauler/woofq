If PuppyPin has this entry (within <pinboard></pinboard>):

  <backdrop style="Stretched">/usr/share/backgrounds/default.jpg</backdrop>

Then that will be the background image. If that line is missing, Rox fills
the background with the current GTK2 theme window background colour.

To choose a backdrop image, right-click on any desktop icon, and there is an
entry labeled "Backdrop..."

2022
----
note, 3buildeasydistro copies globicons and PuppyPin to rootfs-complete,
overriding those files that may have been installed by rox-filer pkg.

