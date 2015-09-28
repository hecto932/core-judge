#REFERENCES : https://github.com/mjnaderi/Sharif-Judge/blob/7ca3101bb848447e8d8aabb14aae0d6ae9dfde31/tester/shield/shield_py3.py
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
    #'input'
]

#PARA CADA MODULO DE LA BLACKLIST
for module in BLACKLIST:
    #VERIFICAMOS SI ESTA EN LA LISTA DE MODULOS
    if module in __builtins__.__dict__:
        #LA ELIMINAMOS
        del __builtins__.__dict__[module]

