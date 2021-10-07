# frozen_string_literal: true

module Polycon
  module Model
    class Professional
      attr_accessor :name, :surname, :path

      def initialize(name: name, surname: surname)
        self.name = name
        self.surname = surname
        self.path = (@name + "_" + @surname + '/').upcase
      end

      def self.all()
        Polycon::Store::ensure_root_exists
        Polycon::Store::entries(Polycon::Store::PATH)
      end 

      def self.create(name:, **)
        Polycon::Store::ensure_root_exists
        firstname, surname = name.split(" ")
        professional = new(name: firstname, surname: surname)
        raise InvalidProfessional unless professional.valid?
        raise AlreadyExists if Polycon::Store::exist?(professional)
        professional.save()
        professional
      end

      def delete(name: nil)
        Polycon::Store::ensure_root_exists
        Polycon::Store::delete(professional: self) unless self.has_appointments?
      end

      def has_appointments?
        Polycon::Store::ensure_root_exists
        Polycon::Store::entries(self.path).empty?
      end 

      def self.rename(old_name:, new_name:)
        Polycon::Store::ensure_root_exists
        old_professional = create(name:old_name)
        new_professional = create(name:new_name)
        Polycon::Store.rename(old_name: old_name, new_name: new_name)
      end

      def to_s
        "name: " + (@name + " " + @surname).upcase + " => file path: " + Storage::ROOT_DIR+self.path
      end 
      protected
      def save()
        Polycon::Store::save(self)
      end 

    end



  end
end
