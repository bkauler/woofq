#!/bin/sh

#20240313 moved from FIXUPHACK...
#20211112
if [ -e etc/asound.conf ];then #20230915 void
 rm -f etc/asound.conf
fi
if [ -e usr/share/alsa/alsa.conf.d/50-oss.conf ];then #20230915 void
 rm -f usr/share/alsa/alsa.conf.d/50-oss.conf
fi
mkdir -p etc/alsa/conf.d
rm -f etc/alsa/conf.d/50-oss.conf 2>/dev/null
rm -f etc/alsa/conf.d/99-pulseaudio-default.conf 2>/dev/null
echo '# Default to PulseAudio

pcm.!default {
    type pulse
    hint {
        show on
        description "Default ALSA Output (currently PulseAudio Sound Server)"
    }
}

ctl.!default {
    type pulse
}' > etc/alsa/conf.d/99-pulseaudio-default.conf
 
