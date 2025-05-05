class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :type, null: false # STI type
      t.references :eventable, null: false, polymorphic: true, index: true
      t.jsonb :properties, null: false, default: {}

      t.timestamps
    end
  end
end
