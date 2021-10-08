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
        raise Dry::Files::Error
      end
    end

    def self.save(obj)
      begin
        if obj then
          @files.directory?(PATH+obj.path) ? write_dir(PATH+obj.path) : write(obj)
        else 
          raise Dry::Files::Error, "Nil value argument." 
        end 
      rescue 
        raise Dry::Files::Error
      end
    end

    def self.read(obj)
      return nil if @files.directory?(PATH+obj.path)
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
        if old_name && new_name then
          @files.directory?(PATH+old_name.path) ? @files.copy_dir(old_name,new_name) : @files.copy_file(old_name,new_name)
          delete(old_name)
        else 
          raise Dry::Files::Error, "Nil value argument." 
        end 
      rescue 
        raise Dry::Files::Error
      end

    end 

    def self.delete(obj)
      begin
        if obj then
          @files.directory?(PATH+obj.path) ? @files.rm_rf(PATH+obj.path) : @files.rm(PATH+obj.path)
        else 
          raise Dry::Files::Error, "Nil value argument." 
        end 
      rescue 
        raise Dry::Files::Error
      end
    end 

    def self.entries(directory:)
      begin
        if directory then
          Dir.entries(PATH+directory)
        else 
          raise Dry::Files::Error, "Nil value argument." 
        end 
      rescue  
        raise Dry::Files::Error
      end
    end 

    protected

    def copy_dir(old_name,new_name)
      begin
        FileUtils.mv PATH+old_name.path, PATH+new_name.path
      rescue  
        raise Dry::Files::Error
      end
    end

    def copy_file(old_name,new_name)
      begin
          @files.cp PATH+old_name.path, PATH+new_name.path
      rescue  
        raise Dry::Files::Error
      end
    end 

    def self.write_dir(obj)
      begin 
        raise Dry::Files::Error if @files.directory?(PATH+obj.path)
        @files.mkdir(PATH+obj.path)
      rescue 
         raise Dry::Files::Error
      end 
    end 

    def self.write(obj)
      begin
        @files.write(PATH+obj.path, obj.surname)
        @files.append(PATH+obj.path, obj.name) 
        @files.append(PATH+obj.path, obj.phone)
        @files.append(PATH+obj.path, obj.notes) if obj.notes
      rescue 
        raise Dry::Files::Error 
      end
    end 

  end 
end 