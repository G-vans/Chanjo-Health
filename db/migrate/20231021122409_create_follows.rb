class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.string :name
      t.string :phone_number

      t.timestamps
    end
  end
end
