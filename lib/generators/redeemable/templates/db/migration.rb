class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      t.integer :user_id
      t.integer :redeemed_by_id, :integer

      t.string :code

      t.timestamps
      t.timestamp :redeemed_at
      t.timestamp :expires_at
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
