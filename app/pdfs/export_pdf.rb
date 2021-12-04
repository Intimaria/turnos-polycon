class ExportPdf < Prawn::Document
    include Utils

    HEADER = ["Hora", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes"].freeze
    START = "07:30"

    def initialize(professional, view, date, type)
        super()
        @professional = professional
        @view = view
        @date = date
        @appts = Utils.get_appointments(professional: @professional)
        @slots = Utils.horarios(START)

        if type == :day 
            text "Professional #{@professional.to_s}, #{type}, #{date}"
            export_day
        else 
            text "Professional #{@professional.to_s}, #{type}, #{date}"
        end 
    end

    def export_day

        appts = @appts.filter do |appt|
          appt.date == @date
        end

        filas = Array.new(@slots.size) { Array.new(2) }
        filas[0][0] = "Appointments"
        filas[0][1] = "#{I18n.l(@date, format: '%A, %B %d, %Y')}"

        (1...@slots.size).each do |row|
        (0...1).each do |cell|
            filas[row][0] = slots[row]
            arr = Array.new
            appts.each do |a|
            if a.time.strftime('%H:%M') == @slots[row]
                arr << ["#{a.name} #{a.surname} \n#{"(" + a.professional.to_s + ")" unless @professional}"]
                filas[row][1] = make_table(arr, :cell_style => { :overflow => :shrink_to_fit, :max_font_size => 8,
                                                                :height => 40, :borders => [:bottom] })
            end
            end
        end
        end

        table(filas) do
            cells.borders = []

            row(0).borders          = [:bottom]
            row(0).border_width     = 2
            row(0).background_color = "FF9900"
            row(0).font_style       = :bold

            # columns(0..slots.size).borders = [:right]

            row(0..@slots.size).columns(0..1).borders = [:top, :bottom, :left, :right]
        end 
    
    end



    def export_week

        appts = get_appointments(professional:professional)
        
        now = Date.parse(date)
        monday = now - (now.wday - 1) % 7
  
        appts.flatten!
  
        appts.filter! do |appt|
          Date.parse(appt.date.to_s).between?(monday, monday + 6)
        end
  
        slots = horarios(date)
  
        Prawn::Document.generate('turnos.pdf', :page_layout => :landscape) do
          text "Profesional: #{professional.to_s.upcase}" if professional
          text "For week of #{monday}"
          filas = Array.new(slots.size) { Array.new(2) }
          (0...HEADER.size).each do |col|
            filas[0][col] = HEADER[col]
          end
  
          (1...slots.size).each do |row|
            (0...HEADER.size).each do |cell|
              filas[row][0] = slots[row]
              filas[row][cell] = " "
              arr = Array.new
              appts.each do |a|
                if (a.to_h[:hour] == filas[row][0] && Date.parse(a.to_h[:date]).wday == cell)
                  arr << ["#{a.name} #{a.surname} \n#{"(" + a.professional.to_s.downcase + ")" unless professional}"]
                  filas[row][cell] = make_table(arr, :cell_style => { :overflow => :shrink_to_fit, :max_font_size => 8,
                                                                      :height => 40, :borders => [:bottom] })
                end
              end
            end
          end
  
          table(filas, :width => 720) do
            cells.borders = []
  
            # row(0).borders      = [:bottom]
            row(0).width = 72
            row(0).border_width = 2
            row(0).background_color = "FF9900"
            row(0).font_style = :bold
  
            # columns(0..6).borders = [:top, :left]
  
            row(0..slots.size - 1).columns(0..6).borders = [:top, :bottom, :left, :right]
          end
        end
      end



end 

