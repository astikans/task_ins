class CreateApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :applications do |t|
      t.references :job, null: false, foreign_key: true, index: true
      t.string :candidate_name, null: false
      t.jsonb :projection, null: false, default: {}

      t.timestamps
    end

    add_index :applications, :projection, using: :gin
  end
end
