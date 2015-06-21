
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
    #'__import__', #SI ESTE MODULO DE ACTIVA NO PERMITE EL IMPORT DE MODULOS
    'eval', #EVAL ES UN DEMONIO
    'open',
    'file',
    'exec',
    'execfile',
    'compile',
    'reload',
    #'input'
]

#PARA CADA MODULO DE LA BLACKLIST
for module in BLACKLIST:
    #VERIFICAMOS SI ESTA EN LA LISTA DE MODULOS
    if module in __builtins__.__dict__:
        #LA ELIMINAMOS
        del __builtins__.__dict__[module]

