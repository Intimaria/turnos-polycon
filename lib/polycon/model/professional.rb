# frozen_string_literal: true

module Polycon
  module Model
    # This class's responsability is to model Professional objects
    class Professional
      attr_accessor :name, :surname

      class << self

        def all()
          # FIXME: delegate, create store method that returns professionals (no gsub here)
          Polycon::Store.entries(directory: Polycon::Store.root).map! { |p| p.gsub(/_/, ' ') }.sort
        end

        def create(name:, **)
          firstname, surname = name.split(' ')
          professional = new(name: firstname, surname: surname)
          raise InvalidProfessional unless valid?(professional)

          professional
        end

        def find(name:, **)
          firstname, surname = name.split(' ')
          professional = new(name: firstname, surname: surname)
          raise NotFound unless Polycon::Store.exist_professional?(professional)

          professional
        end

        # utility

        def valid?(professional)
          professional && !professional.name.nil? && !professional.surname.nil?
        end

      end

      def initialize(name:, surname:)
        raise ParameterError if name.nil? || surname.nil?

        self.name = name
        self.surname = surname
      end

      def to_h
        {name: name, surname: surname}
      end

      def appointments?
        !Polycon::Store.has_appointments?(self)
      end

      def rename(new_name:)
        new_professional = Professional.create(name: new_name)
        raise InvalidProfessional unless Professional.valid?(new_professional)

        Polycon::Store.rename_professional(old_name: self, new_name: new_professional)
      end

      def delete()
        raise ProfessionalDeletionError if self.appointments? 

        Polycon::Store.delete_professional(self)
      end

      def to_s
        "name: #{@name}  #{@surname}"
      end

      def save()
        raise AlreadyExists if Polycon::Store.exist_professional?(self)

        Polycon::Store.save(professional: self)
      end

      def appointments
        #TODO
        end
      end

    end

    # Professional Errors: General
    class ProfessionalError <Error
      def message; end; end

    # Professional Errors: Creation
    class ProfessionalCreationError < ProfessionalError
      def message
        'Could not create professional.'
      end
    end

    # Professional Errors: Delete
    class ProfessionalDeletionError < ProfessionalError
      def message
        'Could not delete professional as they have appointments.'
      end
    end

    # Professional Errors: Rename
    class ProfessionalRenameError < ProfessionalError
      def message
        'Could not rename professional.'
      end
    end

    # Professional Errors: Invalid
    class InvalidProfessional < ProfessionalError
      def message
        'The professional is invalid. Please revise'
      end
    end
  end
end
