module ApplicationHelper
    def display_date(appointment)
        "#{I18n.l(appointment.date, format: '%A, %B %d, %Y at %H:%M')}"
    end 
end
