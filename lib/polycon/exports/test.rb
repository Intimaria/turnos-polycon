
array1 = ["turnos","Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado", "Domingo"]
array2 = (0..7).to_a
Prawn::Document.generate('implicit.pdf') do
    data = [ array1 ,
    array2,
    array2]

    table(data) do
    cells.padding = 12
    cells.borders = []

    row(0).borders      = [:bottom]
    row(0).border_width = 2
    row(0).font_style   = :bold

    columns(0..7).borders = [:right]

    row(0..array2.size).columns(0..7).borders = [:bottom, :right]
    row(0) = "a"

    end
  end