require 'dry/files'

module Polycon
  module Store 
    # TODO -> define custom errors DONE-ISH
    #     -> return true or false instead of exception (some methods) & validate at Model level
    #     -> import into Models?
    PATH = "#{Dir.home}/.polycon/".freeze
    FORMAT = '%Y-%m-%d_%H-%M'.freeze

    @files = Dry::Files.new

    # PATHS

    def self.ensure_root_exists
      begin
        @files.mkdir(PATH) unless @files.directory?(PATH)
      rescue 
        raise Dry::Files::Error, "problem with root directory"
      end
    end

    def self.root
      ensure_root_exists
      PATH
    end 

    def self.appointment_path(app)
      begin
        "#{professional_path(app.professional)}#{app.date.strftime(FORMAT)}.paf"
      rescue 
        raise Dry::Files::Error, "problem with making appointment file path"
      end
    end 

    def self.professional_path(professional)
      begin
        "#{professional.name.upcase}_#{professional.surname.upcase}/"
      rescue 
        raise Dry::Files::Error, "problem with making professional file path"
      end
    end


    def self.read(professional:,date:)
      path = "#{root}#{professional_path(professional)}#{date.strftime(FORMAT)}.paf"
      return nil if @files.directory?(path)
      begin
        @files.read(path).split(/\n/)
      rescue 
        raise Dry::Files::Error, "problem reading from file"
      end
    end

    def self.exist_professional?(prof)
      begin
          @files.exist?(root+professional_path(prof))
      rescue 
          raise Dry::Files::Error, "The directory or file doesn't exist" 
      end 
    end 

    def self.exist_appointment?(app)
      begin
          @files.exist?(root+appointment_path(app))
      rescue
          raise Dry::Files::Error, "The directory or file doesn't exist" 
      end 
    end 


    def self.all_professionals
      begin
          professionals = Dir.entries(root).reject {|f| f.start_with?(".") }
          professionals.map! { |prof| prof.gsub(/_/, ' ')  } 
      rescue  
        raise Dry::Files::Error, "problem retrieving entries, are you sure that directory exists?"
      end
    end 

    def self.all_appointment_dates(prof)
      begin
        appointment_dates = Dir.entries("#{root}#{professional_path(prof)}").reject {|f| f.start_with?(".") }
        appointment_dates.map! { |f| File.basename(f, File.extname(f)) }
        appointment_dates.map! do |appt| 
           date_arr = appt.split(/_/)
           time = date_arr[1].gsub(/[-]/,":")
           date_arr[0]+" "+time
         end 
        return appointment_dates
      rescue
        raise Dry::Files::Error, "problem retrieving entries, are you sure that directory exists?"
      end
  end
  
  def self.has_appointments?(prof) 
    begin
      !Dir.empty?(root+professional_path(prof))
    rescue
      raise Dry::Files::Error, "problem checking if the professional has appointments" 
    end 
  end  

    def self.rename_professional(old_name:, new_name:)
      begin
         FileUtils.mv(root+professional_path(old_name), root+professional_path(new_name))
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem renaming"
      end
    end 

    def self.rename_appointment(old_app:, new_app:)
      begin
         FileUtils.mv(root+appointment_path(old_app), root+appointment_path(new_app))
      rescue ArgumentError
        raise Dry::Files::Error, "it's possible there is a problem with the date."
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem renaming"
      end
    end 

    def self.save_professional(prof)
      begin
          #TODO - do I need this delegation?
          write_dir(prof) 
      rescue FileCreationError
        raise Dry::Files::Error, "couldn't write file"
      rescue NoMethodError
        raise Dry::Files::Error, "Nil value argument."
      rescue 
        raise Dry::Files::Error, "problem saving"
      end
    end

    def self.save_appointment(appt)
      begin
        #TODO - do I need this delegation?
          write(appt)
      rescue FileCreationError
        raise Dry::Files::Error, "couldn't write file"
      rescue NoMethodError
        raise Dry::Files::Error, "Nil value argument."
      rescue 
        raise Dry::Files::Error, "problem saving"
      end
    end
    

    def self.modify(app, **options)
      begin 
        options.each do |key,value| 
          @files.replace_first_line(root+appointment_path(app), app.to_h[key], value)
        end
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem modifying file"
      end
    end 

    def self.delete_professional(professional)
      begin
         @files.delete_directory(root+professional_path(profesional)) 
      rescue 
        raise Dry::Files::Error, "problem deleting"
      end
    end 

    def self.delete_appointment(app)
      begin
          @files.delete(root+appointment_path(app))
      rescue 
        raise Dry::Files::Error, "problem deleting"
      end
    end 

    def self.write_dir(prof)
      begin 
         if @files.directory?(root+professional_path(prof)) then 
          raise Dry::Files::Error, "the directory already exists"
         end 
        @files.mkdir(root+professional_path(prof))
      rescue 
        raise DirectoryCreationError
      end 
    end 


    def self.write(appt)
      path = appointment_path(appt)
      begin
        @files.write(root+path, appt.surname)
        @files.append(root+path, appt.name) 
        @files.append(root+path, appt.phone)
        @files.append(root+path, appt.notes) if appt.notes
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