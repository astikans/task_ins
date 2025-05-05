class CreateJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.jsonb :projection, null: false, default: {}
      t.jsonb :counters, null: false, default: {}

      t.timestamps
    end

    add_index :jobs, :projection, using: :gin
  end
end
