# frozen_string_literal: true

module Polycon
  module Storage
    ROOT_DIR = Dir.home()+"/.polycon/"
    
    attr_accessor :dir


    def self.get_full_path(file)
      #File.absolute_path
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
  class DirectoryNotFoundError < IOError
    def message
      "The directory was not found."
    end
  end
  class NoPolyconRootError < IOError
    def message
      "The .polycon root folder was not found in the user's home directory."
    end
  end
  class DirectoryCreationError < IOError
    def message 
      "Could not create directory"
    end 
  end 
  class DirectoryRenameError < IOError
    def message 
      "Could not rename directory"
    end 
  end 
end
