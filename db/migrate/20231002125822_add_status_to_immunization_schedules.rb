class AddStatusToImmunizationSchedules < ActiveRecord::Migration[7.0]
  def change
    add_column :immunization_schedules, :status, :boolean, default: false
  end
end
