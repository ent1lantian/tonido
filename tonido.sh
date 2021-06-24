#! /bin/bash
#
# tonido        Start the Tonido server
#
# Author:       Madhan Kanagavel <madhan@codelathe.com>
#

set -e

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
NAME=tonidoconsole
USER=`whoami`
DESC="Tonido Service"
TONIDODIR=`dirname $0`
PIDFILE=/tmp/tonido_$USER.pid
LOGFILE=/tmp/tonido_$USER.log

# Gracefully exit if the package has been removed.
test -x $TONIDODIR/tonidoconsole || exit 0

case "$1" in
  start)
	# Gracefully exit if the package has been removed.
	test -x $TONIDODIR/tonidoconsole || exit 100
	test -f $TONIDODIR/norestart && exit 0
  
        echo -n "Starting $DESC:"
        (cd $TONIDODIR && \
	   export LD_LIBRARY_PATH=. &&
	   exec nohup 2>&1 $TONIDODIR/tonidoconsole \
	   1>$LOGFILE) &
	echo $! > $PIDFILE;
        ;;
  stop)
        echo "Stopping $DESC: $NAME."
        kill -9 `cat  $PIDFILE` &> /dev/null
	rm -f $PIDFILE
        ;;
  restart)
        echo "Restarting $DESC: $NAME."
        $0 stop && sleep 1
        $0 start
        ;;
  *)
        echo "Usage: $0 {start|stop|restart}" >&2
        exit 1
        ;;
esac

exit 0

