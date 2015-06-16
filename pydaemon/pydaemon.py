#!/usr/bin/env python

#LIBRERIAS
import os #LIBRERIA DE SISTEMA OPERATIVO
import sys #LIBRERIA DE PROCESOS
import optparse #LIBRERIA DE PARSEO DE VARIABLES
import time #LIBRERIA DE TIEMPO
import logging #LIBRERIA DE LOGS
from daemon import runner

#AUTORIA DEL CODIGO
__author__ = "Hector Jose Flores Colmenarez"
__licence__ = "MIT"
__version__ = "1.0.1"
__email__ = "hecto932@gmail.com"
__repository__ = "http://github.com/hecto932/TEG"
__status__ = "production"

#MAXIMO DE TAMANO EN MEMORIA (5MB POR DEFECTO)
MAX_SIZE = 5120

#MAXIMO TIEMPO DE EJECUCION (1m:30s POR DEFECTO)
MAX_TIME = 90

#NOMBRE DEL PROCESO
PROCNAME = "pydaemon"

class Daemon:
	#CONSTRUCTOR
	def __init__(self):
		#DISPOSITIVO NULO, ES DECIR, TO THE HELL!
		self.stdin_path = "/dev/null"

		#COMUNICACION DE SALIDA ESTANDAR
		self.stdout_path = "/dev/tty"

		#COMUNICACION DE ERRORES POR SALIDA ESTANDAR
		self.stderr_path = "/dev/tty"

		#CON ESTE ARCHIVO PODEMOS VERIFICAR SI UN PROCESO ESTA CORRIENDO
		self.pidfile_path = "/var/run/pydaemon/pydaemon.pid"
		self.pidfile_timeout = 5

	#CODIGO A DEMONIZAR
	def run(self):
		i = 0
		while True:
			i+=1
			logger.info("Tiempo transcurrido: %s" %i)
			time.sleep(1)

#INSTANCIAMOS LA CLASE DEMONIO
daemon = Daemon()

#DEFINIENDO INSTANCIA DE LA CLASE LOGGIN
logger = logging.getLogger("pydaemon")

#DEFINIENDO EL NIVEL DE LOS MENSAJES
logger.setLevel(logging.INFO)

#DEFINIENDO LA FORMA DEL LOG
formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")

handler = logging.FileHandler("/var/log/pydaemon/pydaemon.log")

handler.setFormatter(formatter)

logger.addHandler(handler)

#EJECUTAMOS EL DEMONIO LLAMANDO A DICHA CLASE
daemon_runner = runner.DaemonRunner(daemon)

#CON ESTO EVITAMOS QUE EL ARCHIVO LOG SE CIERRE DURANTE LA EJECUCION
daemon_runner.daemon_context.files_preserve = [handler.stream]

#EJECUTAMOS EL DEMONIO
daemon_runner.do_action()




