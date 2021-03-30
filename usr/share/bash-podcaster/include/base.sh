#
STARTDATE=$(/bin/date +"%m-%d-%Y")
STARTTIME=$(/bin/date +"%r")

IFISONLINE=$(ping -c2 8.8.8.8 &> /dev/null ; echo $?)
HOST=$(hostname -f)

PROGNAME="bash-podcaster"
MEDIADIR="/mnt/Media/Podcasts/"$title""
USRDIR="/usr/share/$PROGNAME"
LIBDIR="/var/lib/$PROGNAME"
LOGDIR="$LIBDIR/log"
PIDDIR="$LIBDIR/run"
PIDFILE="$PIDDIR/$show.pid"
LOGFILE="$LOGDIR/$show.log"
ERRORLOG="$LOGDIR/$show.err"

TWITURL="http://twit.cachefly.net"

WGETCMD="wget -nv -c -nc -e robots=off -a "$LOGFILE""

QHD="_h264m_1280x720_1872.mp4"
QSD="_h264b_864x480_500.mp4"
QLD="_h264b_640x368_256.mp4"
QAU=".mp3"

SENDMAIL="yes"
SENDMAILONERROR="yes"
MAILFROM="root@$HOST"
MAILRECIP="root@$HOST"
MAILSUB="$show has completed on $HOST"
MAILHEADER="$show started on $STARTDATE at $STARTTIME"
MAILMESS1=""
MAILMESS2=""
MAILMESS3="Either no errors were reported or you have not enabled error reporting"
MAILFOOTER="Please check the $LOGFILE for more information"

if [ ! -d "$LOGDIR" ] ; then mkdir -p  "$LOGDIR"; fi
if [ ! -d "$PIDDIR" ] ; then mkdir -p "$PIDDIR"; fi
if [ ! -d "$MEDIADIR" ]; then mkdir -p "$MEDIADIR" ; fi
if [ ! -d /var/log/$PROGNAME ]; then ln -s $LOGDIR /var/log/$PROGNAME ; fi
if [ ! -d /var/run/$PROGNAME ]; then ln -s $PIDDIR /var/run/$PROGNAME ; fi

