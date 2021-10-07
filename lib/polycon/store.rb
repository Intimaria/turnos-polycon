module Polycon
  module Store 
    
    PATH = Dir.home+'/.polycon/'

    @files = Dry::Files.new
    
    def self.read(file_name:)
      begin
        @files.read(PATH+file_name)
      rescue Dry::Files::Error => exception
        warn exception.message
      end
    end

    def self.ensure_root_exists()
      begin
        @files.mkdir(PATH) unless @files.directory?(PATH)
      rescue Dry::Files::Error => exception
        warn exception.message
      end
    end

    def self.save(professional: nil, appointment: nil)
      begin
        if obj then
          @files.directory?(PATH+obj.path) ? @files.mkdir(PATH+obj.path) : @files.mkdir_p(PATH+obj.path)
        else 
          raise Dry::Files::Error, "Nil value argument." 
        end 
      rescue Dry::Files::Error => exception
        warn exception.message
      end
    end

    def self.rename(old_name:, new_name:)
      begin
        if old_name && new_name then
          @files.cp PATH+old_name.path, PATH+new_name.path
          delete(old_name)
        else 
          raise Dry::Files::Error, "Nil value argument." 
        end 
      rescue Dry::Files::Error => exception
        warn exception.message
      end

    end 

    def self.delete(obj)
      begin
        if obj then
          @files.directory?(PATH+obj.path) ? @files.rm_rf(PATH+obj.path) : @files.rm(PATH+obj.path)
        else 
          raise Dry::Files::Error, "Nil value argument." 
        end 
      rescue Dry::Files::Error => exception
        warn exception.message
      end
    end 

  end 
end 