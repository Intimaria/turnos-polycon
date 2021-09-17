module Polycon
  module Commands
    class Version < Dry::CLI::Command
      desc 'Print version'

      def call(*)
        puts Polycon::VERSION
      end
    end
  end
end
