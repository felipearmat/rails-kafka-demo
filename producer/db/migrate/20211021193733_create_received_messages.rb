class CreateReceivedMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :received_messages do |t|
      t.string :user
      t.text :text

      t.timestamps
    end
  end
end
