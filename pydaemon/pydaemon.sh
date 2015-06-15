#!/bin/bash

case "$1" in

	#INICIAMOS EL DEMONIO
	start)
		echo "Starting service..."
		python /usr/share/pydaemon/pydaemon.py start
	;;

	#PARAMOS EL DEMONIO
	stop)
		echo "Stopping service..."
		python /usr/share/pydaemon/pydaemon.py stop
	;;

	#REINICIAMOS EL DEMONIO
	restart)
		echo "Restarting service..."
		python /usr/share/pydaemon/pydaemon.py restart
	;;

	*)
		echo "Usage: /etc/init.d/demonioprueba.sh {start|stop|restart}"
		exit 1
	;;

esac

exit 0
