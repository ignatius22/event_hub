class AddRecurringToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :recurring, :boolean, default: false
    add_column :events, :recurrence_rule, :string
    add_column :events, :recurrence_end_date, :datetime
    add_reference :events, :parent_event, foreign_key: { to_table: :events }

    add_index :events, :recurring
  end
end
