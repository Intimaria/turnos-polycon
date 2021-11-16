require 'dry/files'

module Polycon
  module Store
    PATH = "#{Dir.home}/.polycon/".freeze
    FORMAT = '%Y-%m-%d_%H-%M'.freeze

    @files = Dry::Files.new

    # PATHS

    def self.ensure_root_exists
      begin
        @files.mkdir(PATH) unless @files.directory?(PATH)
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem with root directory"
      end
    end

    def self.root
      ensure_root_exists
      PATH
    end

    def self.appointment_path(appt)
      begin
        "#{professional_path(appt.professional)}#{appt.date.strftime(FORMAT)}.paf"
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem with making appointment file path"
      end
    end

    def self.professional_path(prof)
      begin
        "#{root}#{prof.name.upcase}_#{prof.surname.upcase}/"
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem with making professional file path"
      end
    end

    def self.read(appointment)
      path = "#{appointment_path(appointment)}"
      return nil if @files.directory?(path)

      begin
        @files.read(path).split(/\n/)
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem reading from file"
      end
    end

    def self.exist_professional?(prof)
      begin
        @files.exist?("#{professional_path(prof)}")
      rescue Dry::Files::Error
        raise Dry::Files::Error, "The directory or file doesn't exist"
      end
    end

    def self.exist_appointment?(appt)
      begin
        @files.exist?("#{appointment_path(appt)}")
      rescue Dry::Files::Error
        raise Dry::Files::Error, "The directory or file doesn't exist"
      end
    end

    def self.all_appointments
      begin
        response = {}
        professionals = all_professionals
        professionals.map! do |prof|
          response[prof] = all_appointment_dates_for_prof(prof)
        end
        response
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem retrieving entries, are you sure that directory exists?"
      end
    end

    def self.all_professionals
      begin
        if !Dir.empty?(root)
          professionals = Dir.entries(root).reject { |f| f.start_with?(".") }
          professionals.map! { |prof| prof.gsub(/_/, ' ') }
        end
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem retrieving entries, are you sure that directory exists?"
      end
    end

    def self.all_appointment_dates_for_prof(prof)
      begin
        appointment_dates = Dir.entries("#{professional_path(prof)}").reject { |f| f.start_with?(".") }
        appointment_dates.map! { |f| File.basename(f, File.extname(f)) }
        appointment_dates.map! do |appt|
          date_arr = appt.split(/_/)
          time = date_arr[1].gsub(/[-]/, ":")
          date_arr[0] + " " + time
        end
        return appointment_dates
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem retrieving entries, are you sure that directory exists?"
      end
    end

    def self.has_appointments?(prof)
      begin
        !Dir.empty?("#{professional_path(prof)}")
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem checking if the professional has appointments"
      end
    end

    def self.rename_professional(old_name:, new_name:)
      begin
        FileUtils.mv("#{professional_path(old_name)}", "#{professional_path(new_name)}")
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem renaming"
      end
    end

    def self.rename_appointment(old_app:, new_app:)
      begin
        FileUtils.mv("#{appointment_path(old_app)}", "#{appointment_path(new_app)}")
      rescue ArgumentError
        raise Dry::Files::Error, "it's possible there is a problem with the date."
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem renaming"
      end
    end

    def self.save_professional(prof)
      begin
        write_dir(prof)
      rescue DirectoryCreationError
        raise Dry::Files::Error, "couldn't write directory"
      rescue NoMethodError
        raise Dry::Files::Error, "Nil value argument."
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem saving"
      end
    end

    def self.save_appointment(appt)
      begin
        write_file(appt)
      rescue FileCreationError
        raise Dry::Files::Error, "couldn't write file"
      rescue NoMethodError
        raise Dry::Files::Error, "Nil value argument."
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem saving"
      end
    end

    def self.modify(appt, **options)
      begin
        options.each do |key, value|
          @files.replace_first_line("#{appointment_path(appt)}", appt.to_h[key], value)
        end
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem modifying file"
      end
    end

    def self.delete_professional(prof)
      begin
        @files.delete_directory("#{professional_path(prof)}")
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem deleting"
      end
    end

    def self.delete_appointment(appt)
      begin
        @files.delete("#{appointment_path(appt)}")
      rescue Dry::Files::Error
        raise Dry::Files::Error, "problem deleting"
      end
    end

    def self.write_dir(prof)
      begin
        if @files.directory?("#{professional_path(prof)}")
          raise Dry::Files::Error, "the directory already exists"
        end

        @files.mkdir("#{professional_path(prof)}")
      rescue Dry::Files::Error
        raise DirectoryCreationError
      end
    end

    def self.write_file(appt)
      path = appointment_path(appt)
      begin
        @files.write(path, appt.surname)
        @files.append(path, appt.name)
        @files.append(path, appt.phone)
        @files.append(path, appt.notes) if appt.notes
      rescue Dry::Files::Error
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
