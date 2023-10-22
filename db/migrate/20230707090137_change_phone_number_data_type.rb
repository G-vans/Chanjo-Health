class ChangePhoneNumberDataType < ActiveRecord::Migration[7.0]
  def change
    change_column :children, :phone_number, :string
  end
end
