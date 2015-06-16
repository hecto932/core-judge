#******************************************
# * FILE: shield_python2.py               *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
#******************************************

#LIBRERIAS
import sys
sys.modules['os'] = None #EXCLUYE OS

#LISTA DE MODULOS A NO PERMITIR
BLACKLIST = [
    #'__import__', #SI ESTE MODULO SE DESCOMENTA NEGAMOS CUALQUIER TIPO DE IMPORTE DE MODULOS
    'eval', #EVAL ES UN DEMONIO
    'open',
    'file',
    'exec',
    'execfile',
    'compile',
    'reload',
    'input' #INPUT EN PYTHON2 USA EVAL
]

#PARA CADA MODULO DE LA BLACKLIST
for module in BLACKLIST:
    #VERIFICAMOS SI ESTA EN LA LISTA DE MODULOS
    if module in __builtins__.__dict__:
        #LA ELIMINAMOS
        del __builtins__.__dict__[module]