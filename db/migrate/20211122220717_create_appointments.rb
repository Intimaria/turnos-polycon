class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.belongs_to :professional, null: false, foreign_key: { on_delete: :cascade}
      t.string :name
      t.string :surname
      t.string :phone
      t.text :notes
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
