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

__Refactoring a futuro__

Se agregan metodos to_h a professional y appointment para tener mayor facilidad de refactorizar algunas funcionalidades en un futuro.  


### Preguntas 
-> herencia de errores en la jerarquia de namespaces 
-> separacion utils de storage para el futuro
-> como usar options en dry::cli 
-> como hacer monkey patching dentro de un programa asi? (agregar funcionalidad a Dry::Files)

### Errores / Bugs
-> ~~Al renombrar la separacion de nombre y apellido no se hace correctamente~~
-> ~~Cuestiones de lanzamiento de excepciones~~ 
-> From file tiene bug - se guardan las variables "correctamente" pero reescribe el to_s de tal manera que queda "notas" como representacion.
-> Chequear que la hora esta en un rango (guardar rango en clase no hardcoradearlo) para evitar bug de que se crea bien aunque no se pasen bien los horarios y quede 00-00
-> ~~Necesito preguntar en "create" si ya existe el profesional? solo estoy creando un objeto. Como mucho, en save() deberia haber ese chequeo~~
-> Ordenar los appointment por fecha en el List sin fecha
-> A futuro: Agarrar todos los appointment del sistema?
-> Pasar cancel y reschedule a metodos de instancia


