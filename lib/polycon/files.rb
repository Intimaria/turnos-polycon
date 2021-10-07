module Polycon
  module Files 
    
    PATH = Dir.home+'/.polycon/'

    @files = Dry::Files.new
    
    def self.read(file_name:)
      begin
        @files.read(PATH+file_name)
      rescue Dry::Files::Error => exception
        # rescue all the dry-files exceptions
        warn exception.message
      end
    end

    def self.ensure_root_exists()
      begin
        @files.mkdir(PATH) unless @files.directory?(PATH)
      rescue Dry::Files::Error => exception
        # rescue all the dry-files exceptions
        warn exception.message
      end
    end

    def self.save(professional: nil, appointment: nil)
      begin
        if appointment then 
          @files.mkdir_p(PATH+profesional+appointment) unless @files.exist?(PATH+profesional+appointment)
        else 
          @files.mkdir(PATH+profesional) unless @files.directory?(PATH+profesional)
        end
      rescue Dry::Files::Error => exception
        # rescue all the dry-files exceptions
        warn exception.message
      end
    end

  end 
end 