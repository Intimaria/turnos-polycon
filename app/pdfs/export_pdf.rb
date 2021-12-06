class ExportPdf < Prawn::Document
  HEADER = ["Hora", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes"].freeze
  START = "07:30"
  @@slots = Utils.hours(START)

  def initialize(date:, type:, professional: nil)
    puts type
    if type == :week
      super(:page_layout => :landscape)
    else
      super(:page_layout => :portrait)
    end

    if professional
      @professional = professional
    end
    @appts = Utils.get_appointments(professional: @professional)
    @date = date

    if type == :week
      export_week
    else
      text "#{@professional.to_s if @professional} #{type}, #{date}"
      export_day
    end
  end

  def export_day
    appts = @appts.filter do |appt|
      appt.date == @date
    end

    filas = Array.new(@@slots.size) { Array.new(2) }
    filas[0][0] = "Appointments"
    filas[0][1] = "#{I18n.l(@date, format: '%A, %B %d, %Y')}"

    (1...@@slots.size).each do |row|
      (0...1).each do |cell|
        filas[row][0] = @@slots[row]
        arr = Array.new
        appts.each do |a|
          if a.time.strftime('%H:%M') == @@slots[row]
            arr << ["#{a.name} #{a.surname} \n#{"(" + a.professional.to_s + ")" unless @professional}"]
            filas[row][1] = make_table(arr, :cell_style => { :overflow => :shrink_to_fit,
                                                             :max_font_size => 8,
                                                             :height => 40, :borders => [],
                                                             :padding => 2, :margins => 2 })
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

      # columns(0.@slots.size).borders = [:right]

      row(0..@@slots.size).columns(0..1).borders = [:top, :bottom, :left, :right]
    end
  end

  def export_week
    monday = @date - (@date.wday - 1) % 7

    appts = @appts.filter do |appt|
      appt.date.between?(monday, monday + 6)
    end

    text "For week of #{monday} #{@professional.to_s if @professional}"
    filas = Array.new(@@slots.size) { Array.new(2) }

    p filas

    (0...HEADER.size).each do |col|
      filas[0][col] = HEADER[col]
    end

    (1...@@slots.size).each do |row|
      (0...HEADER.size).each do |cell|
        filas[row][0] = @@slots[row]
        filas[row][cell] = " "
        arr = Array.new
        appts.each do |a|
          if ((a.time.strftime('%H:%M') == @@slots[row]) && (a.date.wday == cell)) then
            arr << ["#{a.name.first}. #{a.surname}\n#{"(" + a.professional.to_s + ")" unless @professional}"]
            filas[row][cell] = make_table(arr, :cell_style => { :overflow => :shrink_to_fit, :margin => 0, :max_font_size => 6,
                                                                :height => 40, :borders => [], :padding => [0, 0, 5, 0] })
          end
        end
      end
    end

    table(filas, :width => 760) do
      cells.borders = []
      cells.padding = 2
      # row(0).borders      = [:bottom]
      row(0).width = 50
      row(0).border_width = 2
      row(0).background_color = "FF9900"
      row(0).font_style = :bold

      # columns(0..6).borders = [:top, :left]

      row(0..@@slots.size - 1).columns(0..6).borders = [:top, :bottom, :left, :right]
    end
  end
end
