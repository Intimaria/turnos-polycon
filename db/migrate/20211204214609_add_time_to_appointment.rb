class AddTimeToAppointment < ActiveRecord::Migration[6.1]
  def change
    add_column :appointments, :time, :time
    change_column :appointments, :date, :date
  end
end
