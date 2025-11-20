class AddPgSearchToEvents < ActiveRecord::Migration[7.1]
  def change
    # Enable pg_trgm extension for fuzzy search
    enable_extension 'pg_trgm' unless extension_enabled?('pg_trgm')

    # Add GIN index for full-text search on title and description
    add_index :events, :title, using: :gin, opclass: :gin_trgm_ops
    add_index :events, :description, using: :gin, opclass: :gin_trgm_ops
  end
end
