class AddTotalToProfessional < ActiveRecord::Migration[6.1]
  def change
    add_column :professionals, :total, :integer, default: 0
  end
end
