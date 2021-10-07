
Options

Se toma la decision de usar opciones en la linea de comandos. 

Links
[Dry::CLI::Command documentation] (https://dry-rb.org/gems/dry-cli/0.6/)

Modulo Storage

Extra libraries (included)
[Dir documentation] (https://ruby-doc.org/core-2.7.3/Dir.html#method-c-entries)
[FileUtils documentation] (https://ruby-doc.org/stdlib-2.7.3/libdoc/fileutils/rdoc/FileUtils.html)

Se incluye el modulo Polycon::Storage que tiene metodos relacionados con el manejo de archivos, inclusive metodos helper para saber si existen archivos, y tambien es el modulo que sabe crear directorios, para el archivo root, y para guardar profesionales y leer archivos de turnos en Polycon. 

Se considero usar un modulo Utils pero se considera que Storage maneja las responsabilidades de archivos para Polycon, la utilidad de un modulo Utils que haga queries por existencia de archivos o directorios se hace redundante.  

Preguntas 
-> herencia de errores en la jerarquia de namespaces 
-> separacion utils de storage para el futuro
-> como usar options en dry::cli 

Errores / Bugs
-> Al renombrar la separacion de nombre y apellido no se hace correctamente 
-> Cuestiones de lanzamiento de excepciones 
