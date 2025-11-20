class AddQrCodeToRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :registrations, :qr_code_token, :string
    add_column :registrations, :checked_in, :boolean, default: false
    add_column :registrations, :checked_in_at, :datetime

    add_index :registrations, :qr_code_token, unique: true
  end
end
