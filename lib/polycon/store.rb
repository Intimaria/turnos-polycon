module Polycon
  module Store 
    #TODO -> define custom errors DONE-ISH
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

    def self.read(path)
      return nil if @files.directory?(PATH+path)
      begin
          File.read(PATH+path).split(/\n/)
      rescue 
        raise Dry::Files::Error, "problem reading from file"
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
          files = Dir.entries(directory).reject {|f| f.start_with?(".") }
          files.map! { |f| File.basename(f, File.extname(f)) }
        else 
          raise Dry::Files::Error, "Nil value argument." 
        end 
      rescue  
        raise Dry::Files::Error, "problem retrieving entries"
      end
    end 

    def self.exist?(path)
      begin
        if path then
          @files.exist?(PATH+path)
        else 
          raise Dry::Files::Error, "The file doesn't exist" 
        end 
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
         if @files.directory?(PATH+obj.path) then 
          raise Dry::Files::Error, "the directory already exists"
         end 
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
    class DirectoryRenameError < Dry::Files::Error
      def message 
        "Could not rename directory"
      end 
    end 

  end 
end 