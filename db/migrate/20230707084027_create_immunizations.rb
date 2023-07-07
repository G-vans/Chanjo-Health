class CreateImmunizations < ActiveRecord::Migration[7.0]
  def change
    create_table :immunizations do |t|
      t.string :vax_name
      t.date :date
      t.references :child, null: false, foreign_key: true
      t.references :medic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
