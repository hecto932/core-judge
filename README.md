# Demonios en Linux con Python

Un proceso daemon (o desacoplado de la terminal) que se comporte correctamente en entornos UNIX require una programación especifica, pero una vez hecho uno, hecho todos.

El package daemon de Python sigue la especificación del PEP 3143, definiendo un contexto que ofrece el comportamiento y la configuración de entorno para que un programa escrito en Python adquiera el estado de daemon. Tras un año de uso, esta librería demostró ser incompleta, sobredimensionada e inestable para nuestro gusto.

Hay tres condiciones que nos indican que un proceso pueda considerarse un demonio:

* Su padre debe ser el proceso init
* Debe ser el lider de la sesión
* No puede estar asociado a ninguna terminal.


