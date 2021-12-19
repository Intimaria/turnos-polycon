class ChangeColumnNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null(:professionals, :name, false, "")
    change_column_null(:professionals, :surname, false, "")
    change_column_null(:professionals, :title, false, "")
    change_column_default(:professionals, :name, "")
    change_column_default(:professionals, :surname, "")
    change_column_default(:professionals, :title, "")

    change_column_null(:appointments, :name, false, "")
    change_column_null(:appointments, :surname, false, "")
    change_column_null(:appointments, :phone, false, "")
    change_column_null(:appointments, :date, false)
    change_column_null(:appointments, :time, false)
    change_column_default(:appointments, :name, "")
    change_column_default(:appointments, :surname, "")
    change_column_default(:appointments, :phone, "")
  end
end
