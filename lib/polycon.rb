# frozen_string_literal: true

module Polycon
  autoload :VERSION,  'polycon/version'
  autoload :Commands, 'polycon/commands'
  autoload :Model,    'polycon/model'
  autoload :Utils,    'polycon/utils'
  autoload :Storage,  'polycon/storage'
  autoload :Files,    'polycon/files'
  # Agregar aquí cualquier autoload que sea necesario para que se cargue las clases y
  # módulos del modelo de datos.
  # Por ejemplo:
  # autoload :Appointment, 'polycon/appointment'
  class NotFound < StandardError
    def message
      "What you are looking for is not to be found"
    end
  end

  class AlreadyExists < StandardError
    def message
      "What you wish to create already exists"
    end
  end

end
