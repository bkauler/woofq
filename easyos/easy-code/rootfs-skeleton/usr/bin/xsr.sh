#!/bin/sh
# X Screen Recorder by stemsee
# Copyright (C) 2025 stemsee <cou645@gmail.com/>
## gpl 3 license applies for personal unpaid uses,
# https://www.gnu.org/licenses/gpl-3.0.txt
# else a Unique Arbitrary License 
# must be obtained from the Copyright holder.
# Use at own risk. No liability accepted.
#

export SP=$$

if [[ $(id -u) -ne 0 ]]; then
	[[ "$DISPLAY" ]] && exec gtksu "xsr.sh" "$0" "$@" || exec su -c "$0 $*"
fi

[ ! -f /tmp/timer-$SP ] && cp $(type -p yad) /tmp/timer-$SP

for i in xrectsel arecord ffmpeg yad xdotool
do
	[[ -z "$(type -p $i)" ]] && echo "$i" >> /tmp/deps
done
echo "Missing Dependencies $deps"
if [[ -e /tmp/deps ]]; then
	deps="$(cat /tmp/deps)"
	yad --splash --text="XSR - These dependencies are missing! $deps" --fontname="sans 40" --no-buttons --timeout=4
	rm -f /tmp/deps
	exit
fi

function screenshotfn {
DATE=$(date +%y%m%d%H%M%S)
# window="$(xwininfo | grep id: | cut -f4 -d' ')";xwd -frame -name "$window" -out file.xwd; ffmpeg -i file.xwd  outpit.png -y
IFS='+' read -r O P Q <<<"$(xrectsel)";sleep 0.4;ffmpeg -y -t 00:00:01 -f x11grab -re -video_size "$O" -i :0.0+"$P","$Q" -vf scale="$1":-1 /root/xsr-"$DATE".png
updatefn
};export -f screenshotfn

function recordfn {
. /tmp/ssrvars
export DATE=$(date +%Y%m%d%H%M%S)
	case "$1" in
end) export ID=$(xwininfo -name "X Screen Recorder $SP" | grep id: |  awk '{print $4}')
xdotool windowactivate "$ID"
xdotool windowraise "$ID"
killall  timer-"$SP"
#kill "$ffpd"
#kill "$arpd"
kill $(pgrep -n ffmpeg)
kill $(pgrep -n arecord)
rm -f /tmp/temp-"$DATE".wav
rm -f ffmpeg-*.log
#rm -f /tmp/ssrvars
sleep 1
;;
pause) pkill -STOP ffmpeg;;
cont) pkill -CONT ffmpeg;;
start) [ ! -p /tmp/arec ] && mkfifo /tmp/arec
exec 8<>/tmp/arec
IFS='+' read -r O P Q <<<"$(xrectsel)"
arecord -D"$device" -c2 -f"$qual" -twav /tmp/temp-"$DATE".wav 2>/tmp/arec &
echo "arpd=$!" >>/tmp/ssvars
[[ -z "$(xwininfo -name "XSR reporting $SP" 2>/dev/null)" ]] && /tmp/timer-$SP --no-buttons --title="XSR reporting $SP" \
--text-info --listen --tail --geometry=378x109-0+700 <&8 &

while [ ! -f /tmp/temp-"$DATE".wav ]; do
sleep 0.1
done

ffmpeg -hide_banner -nostats -loglevel 0 -report -re -i /tmp/temp-"$DATE".wav -f x11grab -thread_queue_size 1024 -video_size "${O}" \
-framerate "$framerate" -i :0.0+"${P}","${Q}" -preset ultrafast -c:v libx264 -acodec aac -ab 128k -bufsize 128k -async 2 -vf scale="$width":-1 "$loc"/grab-"$DATE".mp4 2>/tmp/arec &
 echo "ffpd=$!" >>/mp/ssvars
while [[ ! -f "$loc"/grab-"$DATE".mp4 ]]; do
sleep 0.1
done

if [[ -f /tmp/temp-"$DATE".wav && "$loc"/grab-"$DATE".mp4 ]]; then
( cnt=2;while sleep 1;do echo -e '\f';echo "$cnt"; cnt=$((cnt + 1));done ) | /tmp/timer-$SP --no-buttons --geometry=377x109-0+607 \
--skip-taskbar --text-info --on-top --no-buttons --undecorated --geometry=130x18-2+1 --fore=green --back=red --fontname="sans bold 28" &
fi

/tmp/timer-$SP --title="XSR Control $SP" --form --field="Stop":fbtn "bash -c 'recordfn end'" --field="Pause":fbtn "bash -c 'recordfn pause'" \
--field="Continue":fbtn "bash -c 'recordfn cont'" --on-top --geometry="-136+10" --skip-taskbar --undecorated --no-buttons --columns=4 --fontname="sans bold 28" &
export WID=$(xwininfo -name "XSR reporting $SP" | grep id: |  awk '{print $4}')
xdotool windowactivate "$WID"
xdotool windowminimize "$WID"
export ID=$(xwininfo -name "X Screen Recorder $SP" | grep id: |  awk '{print $4}')
xdotool windowactivate "$ID"
xdotool windowminimize "$ID";;
esac
};export -f recordfn

function togiffn {
	DATE=$(date +%Y%m%d%H%M%S)
	FILENAME=$(yad --item-separator='~' --title="XSF Vid to Gif Convertor $SP" --form --field="Select Video":fl "" \
	--field="Options":cb "11~12~22~32~42~62~82~13~23~33~43~63~83~64~84~stream~audio" --title="Make a Gif" \
	--text="Options: 12 = 1fps scale 200 width, 23 = 2fps scale 300 width\n62 = 6fps scale 200 width, 63 = 6fps scale 300 width.")
	IFS='|' read -r vid options <<<"$FILENAME"
	case "$options" in
	11) ffmpeg -y -i "$vid" -loop 0 -filter_complex "fps=1, scale=100:-1" -preset fast "$vid"-"$DATE".gif;;
	12) ffmpeg -y -i "$vid" -loop 0 -filter_complex "fps=1, scale=200:-1" -preset fast "$vid"-"$DATE".gif;;
	22) ffmpeg -y -i "$vid" -loop 0 -filter_complex "fps=2, scale=200:-1" -preset fast "$vid"-"$DATE".gif;;
	32) ffmpeg -y -i "$vid" -loop 0 -filter_complex "fps=3, scale=200:-1" -preset fast "$vid"-"$DATE".gif;;
	42) ffmpeg -y -i "$vid" -loop 0 -filter_complex "fps=4, scale=200:-1" -preset fast "$vid"-"$DATE".gif;;
	62) ffmpeg -y -i "$vid" -loop 0 -filter_complex "fps=6, scale=200:-1" -preset fast "$vid"-"$DATE".gif;;
	82) ffmpeg -y -i "$vid" -loop 0 -filter_complex "fps=8, scale=200:-1" -preset fast "$vid"-"$DATE".gif;;
	13) ffmpeg -y -i "$vid" -loop 0 -filter_complex "fps=1, scale=300:-1" -preset fast "$vid"-"$DATE".gif;;
	23) ffmpeg -y -i "$vid" -loop 0 -filter_complex "fps=2, scale=300:-1" -preset fast "$vid"-"$DATE".gif;;
	33) ffmpeg -y -i "$vid" -loop 0 -filter_complex "fps=3, scale=300:-1" -preset fast "$vid"-"$DATE".gif;;
	43) ffmpeg -y -i "$vid" -loop 0 -filter_complex "fps=4, scale=300:-1" -preset fast "$vid"-"$DATE".gif;;
	63) ffmpeg -y -i "$vid" -loop 0 -filter_complex "fps=6, scale=300:-1" -preset fast "$vid"-"$DATE".gif;;
	83) ffmpeg -y -i "$vid" -loop 0 -filter_complex "fps=8, scale=300:-1" -preset fast "$vid"-"$DATE".gif;;
	64) ffmpeg -y -i "$vid" -loop 0 -filter_complex "fps=6, scale=400:-1" -preset fast "$vid"-"$DATE".gif;;
	84) ffmpeg -y -i "$vid" -loop 0 -filter_complex "fps=8, scale=400:-1" -preset fast "$vid"-"$DATE".gif;;
	stream) ffmpeg -f v4l2 -framerate 25 -video_size 640x480 -i /dev/video0 -preset ultrafast -an -c:v copy -f mpegts https://127.0.0.1:2222?pkt_size=1316;;
	audio) audiof=$(yad --title="Play Audio $SP" --file --width=400 --height=400 )
		aplay "$audiof";;
	esac	
	yad --picture --filename="${vid}"-"$DATE".gif --size=orig --width=600 --height=500 --title="XSR $vid-$DATE.gif $SP"
};export -f togiffn

export devices=$(arecord -L | grep -e 'CARD' | tr '\n' '~')

yad --title="X Screen Recorder $SP" --form --text="           Click Record Button
	         Press left mouse button
	 drag the Crosshairs over a screen area "  --item-separator='~' --field="Output Path":cbe "/root~/tmp~/mnt/sdb2)" --field="Frame Rate":cbe "25~8~12~18~20~22~24~26"  --field="Scale Width":cbe "640~160~320~480~640~800~960~1024~1280~1600~1920" \
--field="Audio Device":cb "$devices" --field="Audio Quality":cb "cd~dat" \
--field="Record":fbtn "bash -c \"echo 'loc="%1"' > /tmp/ssrvars;echo 'framerate="%2"' >> /tmp/ssrvars;echo 'qual="%5"' >> /tmp/ssrvars;echo 'device="%4"' >> /tmp/ssrvars;echo 'width="%3"' >> /tmp/ssrvars;recordfn start \"" \
--field="Stop":fbtn "bash -c 'recordfn end'" --field="Pause":fbtn "bash -c 'recordfn pause'" \
--field="Continue":fbtn "bash -c 'recordfn cont'" --field="Make gif":fbtn "bash -c 'togiffn'" \
--field="ScreenShot":fbtn "bash -c \"screenshotfn "%3" \"" --no-buttons --geometry=377x513-0+69 &

ret=$?
wait $!
case $? in
*) recordfn end
rm -f /tmp/temp-"$DATE".wav
rm -f /tmp/arec;;
esac
