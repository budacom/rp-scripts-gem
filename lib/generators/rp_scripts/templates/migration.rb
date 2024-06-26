class CreateRpScriptsSessions < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :rp_scripts_sessions do |t|
      t.datetime :created_at
      t.string :identifier
      t.boolean :success
      t.datetime :reusable_until
      t.string :description, limit: 255
      t.text :script
      t.text :output
    end

    add_index :rp_scripts_sessions, [:identifier], unique: true
  end
end
