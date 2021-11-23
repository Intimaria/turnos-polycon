class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.references :professional, null: false, foreign_key: true
      t.string :name
      t.string :surname
      t.string :phone
      t.text :notes
      t.datetime :date
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
