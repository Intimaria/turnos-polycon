# Polycon

Plantilla para comenzar con el Trabajo Práctico Integrador de la cursada 2021 de la materia
Taller de Tecnologías de Producción de Software - Opción Ruby, de la Facultad de Informática
de la Universidad Nacional de La Plata.

Polycon es una herramienta para gestionar los turnos y profesionales de un policonsultorio.

Este proyecto es simplemente una plantilla para comenzar a implementar la herramienta e
intenta proveer un punto de partida para el desarrollo, simplificando el _bootstrap_ del
proyecto que puede ser una tarea que consume mucho tiempo y conlleva la toma de algunas
decisiones que más adelante pueden tener efectos tanto positivos como negativos en el
proyecto.

## Uso de `polycon`

Para ejecutar el comando principal de la herramienta se utiliza el script `bin/polycon`,
el cual puede correrse de las siguientes manera:

```bash
$ ruby bin/polycon [args]
```

O bien:

```bash
$ bundle exec bin/polycon [args]
```

O simplemente:

```bash
$ bin/polycon [args]
```

Si se agrega el directorio `bin/` del proyecto a la variable de ambiente `PATH` de la shell,
el comando puede utilizarse sin prefijar `bin/`:

```bash
# Esto debe ejecutarse estando ubicad@ en el directorio raiz del proyecto, una única vez
# por sesión de la shell
$ export PATH="$(pwd)/bin:$PATH"
$ polycon [args]
```

> Notá que para la ejecución de la herramienta, es necesario tener una versión reciente de
> Ruby (2.6 o posterior) y tener instaladas sus dependencias, las cuales se manejan con
> Bundler. Para más información sobre la instalación de las dependencias, consultar la
> siguiente sección ("Desarrollo").

Documentar el uso para usuarios finales de la herramienta queda fuera del alcance de esta
plantilla y **se deja como una tarea para que realices en tu entrega**, pisando el contenido
de este archivo `README.md` o bien en uno nuevo. Ese archivo deberá contener cualquier
documentación necesaria para entender el funcionamiento y uso de la herramienta que hayas
implementado, junto con cualquier decisión de diseño del modelo de datos que consideres
necesario documentar.

## Desarrollo

Esta sección provee algunos tips para el desarrollo de tu entrega a partir de esta
plantilla.

### Instalación de dependencias

Este proyecto utiliza Bundler para manejar sus dependencias. Si aún no sabés qué es eso
o cómo usarlo, no te preocupes: ¡lo vamos a ver en breve en la materia! Mientras tanto,
todo lo que necesitás saber es que Bundler se encarga de instalar las dependencias ("gemas")
que tu proyecto tenga declaradas en su archivo `Gemfile` al ejecutar el siguiente comando:

```bash
$ bundle install
```

> Nota: Bundler debería estar disponible en tu instalación de Ruby, pero si por algún
> motivo al intentar ejecutar el comando `bundle` obtenés un error indicando que no se
> encuentra el comando, podés instalarlo mediante el siguiente comando:
>
> ```bash
> $ gem install bundler
> ```

Una vez que la instalación de las dependencias sea exitosa (esto deberías hacerlo solamente
cuando estés comenzando con la utilización del proyecto), podés comenzar a probar la
herramienta y a desarrollar tu entrega.

### Estructura de la plantilla

El proyecto te provee una estructura inicial en la cual podés basarte para implementar tu
entrega. Esta estructura no es necesariamente rígida, pero tené en cuenta que modificarla
puede requerir algún trabajo adicional de tu parte.

* `lib/`: directorio que contiene todas las clases del modelo y de soporte para la ejecución
  del programa `bin/polycon`.
  * `lib/polycon.rb` es la declaración del namespace `Polycon`, y las directivas de carga
    de clases o módulos que estén contenidos directamente por éste (`autoload`).
  * `lib/polycon/` es el directorio que representa el namespace `Polycon`. Notá la convención
    de que el uso de un módulo como namespace se refleja en la estructura de archivos del
    proyecto como un directorio con el mismo nombre que el archivo `.rb` que define el módulo,
    pero sin la terminación `.rb`. Dentro de este directorio se ubicarán los elementos del
    proyecto que estén bajo el namespace `Polycon` - que, también por convención y para
    facilitar la organización, deberían ser todos. Es en este directorio donde deberías
    ubicar tus clases de modelo, módulos, clases de soporte, etc. Tené en cuenta que para
    que todo funcione correctamente, seguramente debas agregar nuevas directivas de carga en la
    definición del namespace `Polycon` (o dónde corresponda, según tus decisiones de diseño).
  * `lib/polycon/commands.rb` y `lib/polycon/commands/*.rb` son las definiciones de comandos
    de `dry-cli` que se utilizarán. En estos archivos es donde comenzarás a realizar la
    implementación de las operaciones en sí, que en esta plantilla están provistas como
    simples disparadores.
  * `lib/polycon/version.rb` define la versión de la herramienta, utilizando [SemVer](https://semver.org/lang/es/).
* `bin/`: directorio donde reside cualquier archivo ejecutable, siendo el más notorio `polycon`
  que se utiliza como punto de entrada para el uso de la herramienta.
