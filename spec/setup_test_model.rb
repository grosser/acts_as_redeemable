# connect
ActiveRecord::Base.configurations = {"test" => {
  :adapter => "sqlite3",
  :database => ":memory:",
}.with_indifferent_access}

ActiveRecord::Base.establish_connection(:test)

# create tables
ActiveRecord::Schema.define(:version => 1) do
  create_table :free_today_coupons do |t|
    t.integer :user_id, :integer
    t.integer :redeemed_by_id, :integer
    t.string :code, :string
    t.timestamps
    t.timestamp :expires_at
    t.timestamp :redeemed_at
  end
end

# build model
class FreeTodayCoupon < ActiveRecord::Base
  acts_as_redeemable
end