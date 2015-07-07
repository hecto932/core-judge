#SHIELD

##Descripción

El uso de un Shield consiste en poder pre-evaluar las condiciones del archivo fuente a evaluar y poder verificar que este no posee lineas de codigo malicioso que pueda comprometer el desempeño del sistema en donde se ejecutará posteriormente.

###¿Que hacer si queremos agregar un nuevo lenguaje para su pre-evaluación?

1. Lo primero que debemos hacer es agregar el FLAG correspondiente dentro de nuestro archivo shield.sh, con el objetivo de poder identificar, al momento de su ejecucion, lenguaje a pre-evaluar.
2. Dentro de nuestro archivo shield.sh agregamos todas las variables de configuración com