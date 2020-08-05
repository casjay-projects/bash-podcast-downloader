#!/bin/bash
#Download script for The Padres Corner from Twit.TV
PROGPID=$(echo $$)
show="padre"
title="Padres Corner"

source "/usr/share/bash-podcaster/include/base.sh"
echo "Last ran on $(date)" > "$LIBDIR"/$show.txt

if [ "$IFISONLINE" -ne "0" ] ;then
echo "This system does not seam to be online" 2>> $ERRORLOG > $LOGFILE
echo -e "$HOST does not seem to be able to ping 8.8.8.8\nPossibly not online?" | mail -r $MAILFROM -s "$MAILSUB" $MAILRECIP
exit 
fi

if [ -f $PIDFILE ] ; then 
echo -e "$show is already runnning with $PROGPID" > $PIDFILE
exit 1
else

echo $PROGPID > $PIDFILE

echo "Last check was on $(date)" > "$MEDIADIR"/lastcheck.txt

echo -e "$PROG started on $STARTDATE at $STARTTIME" > $LOGFILE 2>$ERRORLOG
echo "Downloading "$title" to $MEDIADIR" >> $LOGFILE

for i in {0030..0001}
do
$WGETCMD "$TWITURL/video/"$show"/"$show""$i"/"$show""$i""$QHD"" -O "$MEDIADIR/$title - S01E$i.mp4"

if [ $? -eq 8 ]; then
find "$MEDIADIR" -size 0 -exec rm -f {} \;
$WGETCMD "$TWITURL/video/"$show"/"$show""$i"/"$show""$i""$QSD"" -O "$MEDIADIR/$title - S01E$i.mp4"
fi

if [ $? -eq 8 ]; then
find "$MEDIADIR" -size 0 -exec rm -f {} \;
$WGETCMD "$TWITURL/video/"$show"/"$show""$i"/"$show""$i""$QLD"" -O "$MEDIADIR/$title - S01E$i.mp4"
fi

if [ $? -eq 8 ]; then
find "$MEDIADIR" -size 0 -exec rm -f {} \;
$WGETCMD "$TWITURL/audio/"$show"/"$show""$i"/"$show""$i""$QAU"" -O "$MEDIADIR/$title - S01E$i.mp3"
fi

find "$MEDIADIR" -size 0 -exec rm -f {} \;

sleep 1s
done

find "$MEDIADIR" -size 0 -exec rm -f {} \;

if [ ! -s $ERRORLOG ] ; then
rm -f $ERRORLOG
if [ $SENDMAIL = "yes" ]; then
echo -e "
$MAILHEADER
$MAILMESS1
$MAILMESS2
$MAILMESS3
$MAILFOOTER\n"| mail -r $MAILFROM -s "$MAILSUB" $MAILRECIP
fi

else
if [ -f $ERRORLOG ] && [ $SENDMAILONERROR == "yes" ]; then
MAILMESS3="$(echo -e "Errors were reported and they are as follows:\n""$(cat $ERRORLOG)")"
echo -e "
$MAILHEADER
$MAILMESS1
$MAILMESS2
$MAILMESS3
$MAILFOOTER\n"| mail -r $MAILFROM -s "$MAILSUB" $MAILRECIP
echo -e "Errors were reported and they are as follows:\n" >> $LOGFILE
cat $ERRORLOG >> $LOGFILE
fi
fi

fi

ENDDATE=$(date +"%m-%d-%Y")
ENDTIME=$(date +"%r")
echo -e "$PROG completed on $ENDDATE at $ENDTIME" >>$LOGFILE 2>>$ERRORLOG
echo -e "Total log Size is $(ls -lh $LOGFILE | awk '{print $5}')" >>$LOGFILE 2>>$ERRORLOG

rm -f $PIDFILE
rm -f $ERRORLOG
echo "exit = $?" >>$LOGFILE
exit $?