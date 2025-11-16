class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :location, null: false
      t.text :address, null: false
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.integer :capacity, null: false
      t.integer :status, default: 0, null: false
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :events, :status
    add_index :events, :starts_at
    add_index :events, [:latitude, :longitude]
  end
end
