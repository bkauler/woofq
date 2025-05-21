#!/bin/sh
# X Screen Recorder by stemsee
# Copyright (C) 2025 stemsee <cou645@gmail.com/>
## gpl 3 license applies for personal unpaid uses,
# https://www.gnu.org/licenses/gpl-3.0.txt
# else a Unique Arbitrary License 
# must be obtained from the Copyright holder.
# Use at own risk. No liability accepted.
#

if [[ $(id -u) -ne 0 ]]; then
	[[ "$DISPLAY" ]] && exec gtksu "xsr.sh" "$0" "$@" || exec su -c "$0 $*"
fi

export SP=$$


( for i in xrectsel yad ffmpeg xdotool arecord
do
[ -z "$(type -p $i)" ] && echo "$i"
done ) | yad --title="Missing Dependencies" --text-info --back=yellow --fore=red --fontname="sans bold 28" --center --width=200 --height=200 --timeout=1

if [[ -z "$(type -p ffmpeg)" ]]||[[ -z "$(type -p yad)" ]];then
	echo "Make sure both ffmpeg and yad are installed!"
	exit 1
fi

[ ! -f /tmp/timer-$SP ] && cp $(type -p yad) /tmp/timer-$SP

function screenshotfn {
DATE=$(date +%y%m%d%H%M%S)
# window="$(xwininfo | grep id: | cut -f4 -d' ')";xwd -frame -name "$window" -out file.xwd; ffmpeg -i file.xwd  outpit.png -y
IFS='+' read -r O P Q <<<"$(xrectsel)";sleep 0.2;ffmpeg -y -t 00:00:01 -f x11grab -re -video_size "$O" -i :0.0+"$P","$Q" -frames:v 1 -vf scale="$1":-1 /root/xsr-"$DATE".png
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
loc=$(echo $loc | sed "s|date|$DATE|")

ffmpeg -hide_banner -nostats -loglevel 0 -report -re -i /tmp/temp-"$DATE".wav -f x11grab -thread_queue_size 1024 -video_size "${O}" \
-framerate "$framerate" -i :0.0+"${P}","${Q}" -preset fast -c:v libx264rgb -crf 0 -acodec aac -ab 128k -bufsize 128k -async 2 -vf scale="$width":-1 -vf setpts=N/FR/TB /root/"$loc" 2>/tmp/arec &
 echo "ffpd=$!" >>/mp/ssvars
while [[ ! -f /root/"$loc" ]]; do
sleep 0.1
done

 #/tmp/timer-$SP --no-buttons --geometry=70x18-2+1 \
#--skip-taskbar --text-info --on-top --no-buttons --undecorated --fore=green --back=red --fontname="sans bold 28" &

if [[ -f /tmp/temp-"$DATE".wav && /root/"$loc" ]]; then
mkfifo /tmp/timepipe
exec 4<>/tmp/timepipe
( cnt=2;while sleep 1;do printf "%s\n%s\n%s\n%s\n" "$cnt" "bash -c 'recordfn end'" "bash -c 'recordfn pause'" "bash -c 'recordfn cont'" >/tmp/timepipe; cnt=$((cnt + 1));done ) &
/tmp/timer-$SP --form --columns=4 --cycle-read --field=:num --field="Stop":fbtn --field="Pause":fbtn \
--field="Continue":fbtn --on-top  --skip-taskbar --undecorated --fontname="sans bold 28" --geometry="80x28-0+0" --no-buttons --title="XSR Control $SP" --listen <&4 &
fi
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
	--field="Frame Rate":cbe "1~2~3~4~5~6~7~8~9~10~11~12" --field="Scale":cbe "100~200~300~400~500~600" --title="Make a Gif" \
	--text="Select Frame Rate and Scale Width")
	IFS='|' read -r vid fps scl<<<"$FILENAME"
	option="fps=$fps, scale=$scl:-1"
	echo -e "#!/bin/sh\nffmpeg -y -i $vid -loop 0 -filter_complex \"$option\" -preset fast $vid-$DATE.gif" > /tmp/op
	chmod 755 /tmp/op
	eval exec /tmp/op
	yad --picture --filename="${vid}"-"$DATE".gif --size=orig --width=600 --height=500 --title="XSR $vid-$DATE.gif $SP"
};export -f togiffn

export devices=$(arecord -L | grep -e 'CARD' | tr '\n' '~')

yad --title="X Screen Recorder $SP" --form --text="           Click Record Button
	         Press left mouse button
	 drag the Crosshairs over a screen area "  --item-separator='~' --field="Output Name.Format":cbe "grab-date.mp4~output.mov~/mnt/sdb2)" --field="Frame Rate":cbe "25~8~12~18~20~22~24~26"  --field="Scale Width":cbe "640~160~320~480~640~800~960~1024~1280~1600~1920" \
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
rm -f /tmp/arec
rm -f /tmp/timer*
rm -f /tmp/ssvars /tmp/ssrvars;;
esac
