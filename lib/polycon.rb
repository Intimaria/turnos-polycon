# frozen_string_literal: true

module Polycon
  autoload :VERSION,  'polycon/version'
  autoload :Commands, 'polycon/commands'
  autoload :Model,    'polycon/model'
  #autoload :Storage,  'polycon/storage' => replaced with use of Dry::Files gem in Store
  autoload :Store,    'polycon/store'

end
