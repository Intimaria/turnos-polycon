
Options

Se toma la decision de usar opciones en la linea de comandos. 

Links
[Dry::CLI::Command documentation] (https://dry-rb.org/gems/dry-cli/0.6/)

Errores de Modelo

Se toma la decision de definir errores especifico al Modelo en el archivo error.rb del modulo Polycon::Model. 

Modulo Store

Extra libraries (included)
[Dir documentation] (https://ruby-doc.org/core-2.7.3/Dir.html#method-c-entries)
[FileUtils documentation] (https://ruby-doc.org/stdlib-2.7.3/libdoc/fileutils/rdoc/FileUtils.html)

Gemas (not included )
[Dry::Files documentation] (https://dry-rb.org/gems/dry-files/0.1/file-system-utilities/)
Correr ``` bundle install ``` al clonar el repo. 

Se incluye el modulo Polycon::Store que tiene metodos relacionados con el manejo de archivos, inclusive metodos helper para saber si existen archivos, y tambien es el modulo que sabe crear directorios, para el archivo root, y para guardar profesionales y leer archivos de turnos en Polycon. 

Se considero usar un modulo Utils pero se considera que Store maneja las responsabilidades de archivos para Polycon, la utilidad de un modulo Utils que haga queries por existencia de archivos o directorios se hace redundante. 

Al principio se usaban las clases Dir y FileUtils, pero luego investgando las gemas de 'dry-rb', se decidio utilizar la gema Dry::Files ya que se adecua de una manera mas limpia a casi todas las utilidades necesarias para el sistema de archivos, y algunas funcoinalidades para modificacion de archivos utiles. Sin embargo, se usa FileUtils y Dir adonde se considera necesario. 

Esta gema Dry::Files define sus propios errores Dry::File::Error y Dry::File::IOError.



Preguntas 
-> herencia de errores en la jerarquia de namespaces 
-> separacion utils de storage para el futuro
-> como usar options en dry::cli 

Errores / Bugs
-> Al renombrar la separacion de nombre y apellido no se hace correctamente 
-> Cuestiones de lanzamiento de excepciones 
