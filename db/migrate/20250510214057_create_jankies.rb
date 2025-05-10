class CreateJankies < ActiveRecord::Migration[7.2]
  def change
    create_table :jankies, id: :uuid do |t|
      t.timestamps
      t.jsonb :locked_attributes, default: {}

      # Add Janky-specific fields
      t.string :janky_level
      t.integer :jankiness_score
    end
  end
end
