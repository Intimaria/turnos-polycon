# frozen_string_literal: true

module Polycon
  module Model
    class Appointment
      attr_accessor :date, :notes, :name, :professional

      def initialize(date:, notes: nil)
        self.date = date
        self.notes = notes
        self.professional = 'someone'
      end

      def create(date:,**options)
        Polycon::Storage.root_exist?
        Polycon::Model::Appointment.create
        puts "creating Appointment for #{options[:professional]} on #{date}"
      rescue NoPolyconRootError => e
        warn e.message
      rescue AppointmentCreationError => e
        warn e.message
      end

      def show(date:, professional:)
        # Polycon::Utils.ensure_polycon_root_exists
      end

      def cancel(date:, professional:)
        # Polycon::Utils.ensure_polycon_root_exists
      end

      def cancel_all(professional:)
        # Polycon::Utils.ensure_polycon_root_exists
      end

      def list(profesional:)
        # Polycon::Utils.ensure_polycon_root_exists
      end

      def reschedule(old_date:, new_date:, professional:)
        # Polycon::Utils.ensure_polycon_root_exists
      end

      def edit(date:, professional:, **options)
        # Polycon::Utils.ensure_polycon_root_exists
      end
    end
  end
end
