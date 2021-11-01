# Entrega 1
## Planificacion 

Se desarrolla un esqumea para los datos. Se considera los objetos y las clases. Se hace un dibujo o esquema para poder visualizar las relaciones. Las relaciones son acotadas. Se considera la necesidad de una entidad que trabaje con archivos para separar el comportamiento de la logica del modelo. Funciona como un adaptador.

Se toma nota de los requisitos a partir del enunciado y se escriben breves historias de usuario y se aggrupan en epicas para dividir la funcionalidad en partes y priorizar. Se consideran algunas tareas adicionales de modelado y de diseño. 

Se planifica con [Jira](https://intimari.atlassian.net/jira/software/projects/POL/boards/1). 

## Options

Se toma la decision de usar opciones en la linea de comandos. 

[Dry::CLI::Command documentation](https://dry-rb.org/gems/dry-cli/0.6/)

## Definicion de Excepciones 

Se toma la decision de definir errores especifico al Modelo en el archivo error.rb del modulo Polycon::Model. 

## Modulo Store

__Extra libraries (included)__

[Dir documentation](https://ruby-doc.org/core-2.7.3/Dir.html#method-c-entries)
[FileUtils documentation](https://ruby-doc.org/stdlib-2.7.3/libdoc/fileutils/rdoc/FileUtils.html)

__Gemas (not included )__

[Dry::Files documentation](https://dry-rb.org/gems/dry-files/0.1/file-system-utilities/)

Correr ``` bundle install ``` al clonar el repo. 

Se incluye en la libreria el modulo Polycon::Store que tiene metodos relacionados con el manejo de archivos. Incluye metodos helper para saber si existen archivos. Tambien sabe crear directorios, para el archivo root y para guardar profesionales. Y sabe leer archivos de turnos de  Polycon. 

Se considero usar un modulo llamado Utils o Helpers pero no por ahora ya que Store maneja las responsabilidades de archivos para Polycon. La utilidad de un modulo Utils que haga queries por existencia de archivos o directorios se hace redundante para esta funcionalidad. No se descarta crear este modulo como forma de modularizar las validaciones y otras utilities si fuera necesario. 

Al principio se usaban las clases principalmente Dir y FileUtils adentro de Store, pero luego investgando las gemas de 'dry-rb', se instala la gema Dry::Files ya que se adecua de una manera mas limpia a las utilidades necesarias para el sistema de archivos, y tiene una agilidad deseable para modificar archivos. Sin embargo, se usa FileUtils y Dir adonde se considera necesario y adonde Dry::Files no alcanza. 

Esta gema define sus propios errores Dry::File::Error y Dry::File::IOError.

## Metodos (clase e instancia)

Originalmente la mayoria de los metodos eran de clase, se refactoriza para usar metodos de instancia para toda la funcionalidad que actua sobre una sola instancia (editar, borrar). Se utiliza metodos de clase para creacion, en la busqueda de una instancia desde un archivo o cuando se debe trabajar sobre varias instancias. 

## Refactoring a futuro 

Se agregan metodos to_h a professional y appointment para tener mayor facilidad de refactorizar algunas funcionalidades en un futuro.  

# Entrega 2


## Mejoras en el codigo

Se cambian `::` por `.` en los llamados a metodos de Store. Se pasan todos los strings concatenados a interpolacion. Se [freezea las constantes](https://hackernoon.com/freeze-your-constants-in-ruby-49e3238c19ef).

Se refactoriza las clases del modelo para quitarle todas las referencias al filesystem (@path etc), aprovechando el modulo Store al 100%. 
Se deshace con una idea de un Store como agnostico, se hace que store conozca appointments y professionals y tenga metodos especailizados para estos. 
Se agrega un metodo de appointments que devuelve todos los appointments para professionals, y appointments? que devuelve true si tiene appointments. 

Se agrega tests usando ['minitest'](https://docs.ruby-lang.org/en/2.1.0/MiniTest.html) para testear la funcionalidad de Polycon.

Se hacen refactorings estrcuturales en base a estos dos ultimos puntos, mejorando toda la funcionalidad.

Se incluye un nuevo modulo utils para poner todas las validaciones del modelo.

## Module Exports

Se implementa una nueva clase heredando de [Dry::CLI::Commands](https://dry-rb.org/gems/dry-cli/0.6/) para los comandos del modulo exports. Se implementa usando un argumento para la fecha y una opcion para profesional.

Se crea un directorio exports en la raiz y se hacen los autoloads necesarios en Polycon.

Se elige [Prawn Table](https://github.com/prawnpdf/prawnhttps://github.com/prawnpdf/prawn-table) para hacer las exportaciones de las grillas de los turnos.


# Notas

### __Preguntas Entrega 1__
- ~~herencia de errores en la jerarquia de namespaces~~
- separacion utils de storage para el futuro
- como usar options en dry::cli 
- como hacer monkey patching dentro de un programa asi? (agregar funcionalidad a Dry::Files)
- Porque no se rescatan todos los argument errors para algunos metodos a pesar de estar en el rescue
- ver adonde hacer el save de appointments / profesionals, esta bien tenerlo afuera o volver a ponerlo en en create?

### __Preguntas Entrega 2__
- Que libreria me conviene usar para exports?

        HAML or Slim - no hay mucha diferencia con ERB. Para PDF hasta ahora encontre Prawn y Origami Otras opciones de templating son Erector y Liquid. Tambien existe un wrapper de Handlebar.js para ruby.
- [Crear PDFs en Ruby (prawn)](https://www.go4expert.com/articles/create-pdf-documents-ruby-t29920/)

- [Doumentacion PrawnTable](https://github.com/prawnpdf/prawnhttps://github.com/prawnpdf/prawn-table) 
- Object Table puede ser una gema intermedia interesante https://github.com/lincheney/ruby-object-table
- hacer que el modulo de exports sea clase con includes del mixin Prawn::Views quizas sea mas elegante/eficiente?
- como hacer que sea mas eficiente / elegante el agregar appointments a grillas? (linea muy larga, O(n^3))

### __Errores / Bugs__
- ~~Al renombrar la separacion de nombre y apellido no se hace correctamente~~
- ~~Cuestiones de lanzamiento de excepciones~~ 
- ~~Necesito preguntar en "create" si ya existe el profesional? solo estoy creando un objeto. Como mucho, en save() deberia haber ese chequeo~~
- ~~Ordenar los appointment por fecha en el List sin fecha~~
- ~~A futuro: Agarrar todos los appointment del sistema?~~
- ~~Pasar cancel y reschedule a metodos de instancia~~
- From file tiene bug - se guardan las variables "correctamente" pero reescribe el to_s de tal manera que queda "notas" como representacion. Esto solo se ve si hago "puts appointment". Si hago "puts appointment.variable, imprime correctamente las variables.
- Chequear que la hora esta en un rango (guardar rango en clase no hardcoradearlo) para evitar bug de que se crea bien aunque no se pasen bien los horarios y quede 00-00. validar que los turnos sean entre el rango de las grillas (constante global?)
- validar que el telefono es un numero
- ~~falta poder comparar los horarios poner un appointment en la grilla~~
- ~~Para insertar appointments en la grilla semanal, comparar el dia de la semana del date con el dia de semana, se usa metodo de instancia de Date .wday, lunes es 1, martes es 2 etc.~~
- mejorar los estilos para las grillas 
- mejorar la eficiencia para la generacion de las grillas 
- ~~en la semana, dos appointments que tienen el mismo dia y horario se pisan~~