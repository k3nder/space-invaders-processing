# Como se juega?
## la descripcion
El juego se basa en que hay un jugador que le dispara a naves eneigas, el jugador se mueve con las flechas del teclado izquiera i derecha i dispara con el espacio, el jugador gana cuando le alla disparado a todas las naves.

Por el contrario las naves enemigas se agupan en filas, i se mueven para los lados, cuando una de las naves enemigas toca un borde, todas las naves que hay se mueven para abajo, cuando
una nave llege al jugador, el jugador abra perdido
## El jugador
El jugador en un cuadrado que hay en la parte inferior del juago, ese jugador se mueve con las flechas del teclado(como ya se menciona en La descripcion).

El jugador puede perder o cuando se le acaban sus vidas, o cuando una nave le sobrepase, entonces el jugador abra perdido.

El jugador puede disparar un rayo laser que puede destruir a las otras naves i cuando
no queden mas naves el jugador pasara al siguiente nivel.

## Las Naves
Las naves son otros cuadrados en la parte superior del juego, estas naves se agrupan en filas (ajustables) i cuando una nave llega al borde todas las demas naves de su fila se mueven al otro lado i bajan una cirta cantidad de pixeles (ajustable), estas naves tambien pueden disparar.

Las naves desaparecen cuando se les atraviesa con el rayo laser del juagdor.

Las naves pueden ganar si al disparale al juagdor le dan i se le acaban las vidas, o cuando sobrepasan al jugador.

# Archivos de configuracion de Propiedades
## Que es?
El archvivo de configuracion de propiedades es un archivo que define las propiedades del jugador i i de las naves, propiedades simples i predeterminadas, este archvio es `conf.default.properties` este archivo esta echo para hacer pruebas i no para hacer el juago mas sencillo.
## Como se usa?
este archivo tiene dicerentes propiedades i es muy facil de configurar, aqui esta la tabla
con el numbre de la configuracion, el valor que se le tiene que dar, el valor predeterminado que hay i la desciption de que hace:

|nombre|tipo de valor|valor predeterminado|descripcion|
|------|-------------|--------------------|-----------|
|nave.separation|numero|10|es la separacion que tienen las naves entre si|
|nave.default.size|numero|20|es el tamaño que tienen las naves, en pixeles|
|nave.velocity|numero|1|es la velocidad a la que se mueven las naves|
|
|player.bottom.distance|numero|16|distancia a la que se encuntra el jugador de la parte de abajo de la pantalla|
|player.size|numero|10|tamaño del jugador|
|player.steps|numero|5|tamaño de los pasos del jugador|
|
|pane.size|numero|900|tamaño del panel del juego|
|
|array.column.size|numero|3|numero de culumnas de naves que hay|
|array.line.size|numero|10|numero de lineas de naves que hay|
|
|bala.maximum.distance|numero|3|distancia maxima de una bala|

El archvo de configuracion se encuentra en la carpeta data