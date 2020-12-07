class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports, id: :uuid do |t|
      t.references :device, null: false, foreign_key: true, type: :uuid
      t.text :sender
      t.text :message
      t.timestamps
    end
  end
end
