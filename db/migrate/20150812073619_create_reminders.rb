class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.string :recipient, null: false
      t.string :title
      t.text :message
      t.datetime :send_at, null: false
      t.boolean :was_sent

      t.timestamps null: false
    end
  end
end
