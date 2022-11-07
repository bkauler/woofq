developer note
--------------

Folder MIME-types has handlers for mime-types.

Some of these are in woofQ rootfs-skeleton/root/Choices/MIME-types,
however most are in the template:
packages-templates/rox-filer/root/Choices/MIME-types

In future, as move away from using rox-filer PET package, and use
'2createpackages' with raw binary pkgs from another distro,
the template is the best place for all these mime-handlers.

...meaning, should look at moving them out of rootfs-skeleton.

Barry Kauler
dec. 2014
