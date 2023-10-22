class CreateImmunizationSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :immunization_schedules do |t|
      t.string :vaxx_name
      t.date :scheduled_date
      t.references :child, null: false, foreign_key: true
      t.references :medic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
