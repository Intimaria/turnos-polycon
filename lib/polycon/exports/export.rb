require 'date'
require 'time'
module Polycon
  module Export
    HEADER = ["Turnos", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes"].freeze

    def self.horarios(date)
      d1 = DateTime.parse(date + " 7:30")
      slots = []
      d2 = d1 + 0.37
      d1.step(d2, 1/48r) { |d| slots << d.strftime('%H:%M') }
      slots
    end
    #   class Export
    #   include Prawn::View
    #   def initialize(name)
    #     @name = name
    #   end
    #   def say_hello
    #     text "Hello, #{@name}!"
    #   end
    #   def say_goodbye
    #     font('Courier') do
    #       text "Goodbye, #{@name}!"
    #     end
    #   end
    #  def render
    #    render_file 'example.pdf'
    #  end
    # end
    # export = Export.new('Gregory')
    # export.say_hello
    # export.say_goodbye
    # export.render

    # def initialize(appointments:, **options)
    #   super(top_margin: 50)
    #   @pdf = Prawn::Document.new
    #   @pdf.text "appointments go here"
    #   @appointments = appointments
    #   if options[:professional]
    #     @professional = options[:professional]
    #   end
    #   table export(appointments: appointments, **options)
    # end
    # def export(appointments:, **options)
    #   puts "here I export all the appointments - options for day week & professional"
    # end

    # def self.export_day(appointments:, **options)
    def self.export_day(date:, professional: nil)
      puts "here I export all appointments for a day"
      if professional
        professional = Polycon::Model::Professional.create(name: professional)
        appts = professional.appointments
      else
        appts = Polycon::Model::Professional.all()
        appts.map! do |prof|
          prof.appointments
        end
        appts.flatten!
      end
      this_date = Date.parse(date)

      appts.filter! do |appt|
        Date.parse(appt.date.to_s) == this_date
      end

      slots = horarios(date)

      Prawn::Document.generate('turnos.pdf') do
        text "Profesional: #{professional.to_s}" if professional
        filas = Array.new(slots.size) { Array.new(2) }
        filas[0][0] = "turnos"
        filas[0][1] = date.to_s

        (1...slots.size).each do |row|
          (0...1).each do |cell|
            filas[row][0] = slots[row]
            appts.each do |a| 
              filas[row][1] = "#{a.name} #{a.surname}  #{"("+a.professional.to_s+")" unless professional}" if a.to_h[:hour] == filas[row][0] 
            end 
          end
        end


        table(filas) do
          cells.padding = 12
          cells.borders = []

          row(0).borders          = [:bottom]
          row(0).border_width     = 2
          row(0).background_color = "FF9900"
          row(0).font_style       = :bold

          #columns(0..slots.size).borders = [:right]

          row(0..slots.size).columns(0..1).borders = [:top, :bottom, :left, :right]
        end
      end
    end

    def self.export_week(date:, professional:)
      puts "here I export all the appointments for a week"
      if professional
        appts = professional.appointments
      else
        appts = Polycon::Model::Professional.all()
        appts.map! do |prof|
          prof.appointments
        end
      end
      now = Date.parse(date)
      monday = now - (now.wday - 1) % 7
      appts.flatten!
      appts.filter! do |appt|
        Date.parse(appt.date.to_s).between?(monday, monday + 6)
      end
      slots = horarios(date)
      Prawn::Document.generate('turnos.pdf') do
        filas = Array.new(slots.size) { Array.new(2) }
        (0...HEADER.size).each do |col|
          filas[0][col] = HEADER[col]
        end

        (1...slots.size).each do |row|
          (0...HEADER.size).each do |cell|
            filas[row][0] = slots[row]
            filas[row][cell] = " "
          end
        end
      
        table(filas) do
          cells.padding = 12
          cells.borders = []

          row(0).borders      = [:bottom]
          row(0).border_width = 2
          row(0).background_color = "FF9900"
          row(0).font_style = :bold

          #columns(0..6).borders = [:top, :left]

          row(0..slots.size - 1).columns(0..6).borders = [:top, :bottom, :left, :right]
        end
      end
    end

    #  Export Errors
    class ExportError
      def message
        "there was a problem processing your export"
      end;
    end
  end
end
