# frozen_string_literal: true

module Polycon
  module Storage
    ROOT_DIR = Dir.home()+"/.polycon/"
    
    attr_accessor :dir

    def initialize
    end

    def self.root_exist?
      Dir.exist?(ROOT_DIR)
    end

    def self.create_root
      begin
        FileUtils.mkdir_p(ROOT_DIR)
      rescue NotFound => e
        warn e.message
      end
    end 

    def self.get_full_path(file)
      #File.absolute_path
    end 

    def self.save( **args)
      save_dir(args[:professional].chomp)
    end

    def self.rename(old_name:, new_name:, **args)
     if args[:professional] then
      rename_dir(old_name: old_name, new_name:new_name) 
     else 
      rename_file(old_name: old_name, new_name:new_nam) 
     end 
    end 

    private

    def self.save_file
    end

    def self.save_dir(path)
      FileUtils.mkdir_p(ROOT_DIR+path) unless Dir.exist?(ROOT_DIR+path)
    end

    def rename_file()
    end 

    def self.rename_dir(old_name:, new_name:, **)
      raise DirectoryNotFoundError unless Dir.exist?(ROOT_DIR+old_name)
      FileUtils.mv ROOT_DIR+old_name, ROOT_DIR+new_name
    end 

  end
  class DirectoryNotFoundError < NotFound
    def message
      "The directory was not found."
    end
  end
  class NoPolyconRootError < NotFound
    def message
      "The .polycon root folder was not found in the user's home directory."
    end
  end
  class DirectoryCreationError < StandardError
    def message 
      "Could not create directory"
    end 
  end 
  class DirectoryRenameError < StandardError
    def message 
      "Could not rename directory"
    end 
  end 
end
