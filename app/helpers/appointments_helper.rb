module AppointmentsHelper
  def display_date(appointment)
    "#{I18n.l(appointment.date, format: '%A, %B %d, %Y')} #{I18n.l(appointment.time, format: 'at %H:%M')}"
  end
end
