module Polycon
  module Store 
    #TODO -> define custom errors 
    #     -> return true or false instead of exception (some methods) & validate at Model level
    #     -> import into Models?
    
    PATH = Dir.home+'/.polycon/'

    @files = Dry::Files.new
    

    def self.ensure_root_exists()
      begin
        @files.mkdir(PATH) unless @files.directory?(PATH)
      rescue 
        raise Dry::Files::Error, "problem with root directory"
      end
    end

    def self.save(professional:nil, appointment:nil)
      begin
        if professional then
          write_dir(professional) 
        else 
          write(appointment)
        end 
      rescue FileCreationError
        raise Dry::Files::Error, "couldn't write file"
      rescue NoMethodError
        raise Dry::Files::Error, "Nil value argument."
      rescue 
        raise Dry::Files::Error, "problem saving"
      end
    end

    def self.read(obj)
      return nil if @files.directory?(PATH+mock_obj.path)
      begin
        File.open(PATH+obj.path, 'r') do |f| 
          obj.surname   = f.gets.chomp
          obj.name      = f.gets.chomp 
          obj.phone     = f.gets.chomp 
          obj.notes     = f.gets.chomp
        end
      rescue NoMethodError 
      ensure 
        #validation done at Model level
        obj
      end
    end 

    def self.rename(old_name:, new_name:)
      begin
         FileUtils.mv(PATH+old_name.path, PATH+new_name.path)
      rescue 
        raise Dry::Files::Error, "problem renaming"
      end

    end 

    def self.delete(obj)
      begin
        if obj then
          @files.directory?(PATH+obj.path) ? @files.delete_directory(PATH+obj.path) : @files.delete(PATH+obj.path)
        else 
          raise Dry::Files::Error, "Nil value argument." 
        end 
      rescue 
        raise Dry::Files::Error, "problem deleting"
      end
    end 

    def self.entries(directory:)
      begin
        if directory then
          Dir.entries(directory).reject {|f| f.start_with?(".")}
        else 
          raise Dry::Files::Error, "Nil value argument." 
        end 
      rescue  
        raise Dry::Files::Error, "problem retrieving entries"
      end
    end 

    def self.empty?(directory:)
      begin
        if directory then
          Dir.empty?(PATH+directory)
        else 
          raise Dry::Files::Error, "Nil value argument." 
        end 
      end 
    end 


    def self.write_dir(obj)
      begin 
        raise Dry::Files::Error if @files.directory?(PATH+obj.path)
        @files.mkdir(PATH+obj.path)
      rescue 
        raise DirectoryCreationError
      end 
    end 

    def self.write(obj)
      begin
        puts "writing #{PATH+obj.path}"
        @files.write(PATH+obj.path, obj.surname)
        @files.append(PATH+obj.path, obj.name) 
        @files.append(PATH+obj.path, obj.phone)
        @files.append(PATH+obj.path, obj.notes) if obj.notes
      rescue 
        return FileCreationError
      end
    end 

    class DirectoryNotFoundError < Dry::Files::Error 
      def message
        "The directory was not found."
      end
    end
    class NoPolyconRootError < Dry::Files::Error 
      def message
        "The .polycon root folder was not found in the user's home directory."
      end
    end
    class DirectoryCreationError < Dry::Files::Error 
      def message 
        "Could not create directory"
      end 
    end 
    class FileCreationError < Dry::Files::Error 
      def message 
        "Could not create file"
      end 
    end 
    class DirectoryRenameError < IOError
      def message 
        "Could not rename directory"
      end 
    end 

  end 
end 