class CreateProfessionals < ActiveRecord::Migration[6.1]
  def change
    create_table :professionals do |t|
      t.string :title
      t.string :name
      t.string :surname
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
