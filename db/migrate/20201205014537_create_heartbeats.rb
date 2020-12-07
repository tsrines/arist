class CreateHeartbeats < ActiveRecord::Migration[6.0]
  def change
    create_table :heartbeats, id: :uuid do |t|
      t.references :device, null: false, foreign_key: true, type: :uuid
      t.datetime 'created_at'
    end
  end
end
