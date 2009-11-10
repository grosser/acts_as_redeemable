require 'spec/spec_helper'

describe ActsAsRedeemable do
  describe :create do
    before :all do
      FreeTodayCoupon.valid_for = 1.day
    end

    after :all do
      FreeTodayCoupon.valid_for = nil
      FreeTodayCoupon.code_length = 6
    end

    it "sets expires_at" do
      FreeTodayCoupon.create!(:user_id => 1).expires_at.should be_close(1.day.from_now, 2)
    end

    it "generates a code" do
      FreeTodayCoupon.create!(:user_id => 1).code.length.should == 6
    end

    it "generates a code of given length" do
      FreeTodayCoupon.code_length = 3
      FreeTodayCoupon.generate_unique_code.length.should == 3
    end
  end

  describe :generate_unique_code do
    it "generates a 6 digit code by default" do
      FreeTodayCoupon.generate_unique_code.length.should == 6
    end

    it "generates a unique code" do
      ActiveSupport::SecureRandom.should_receive(:base64).and_return 'a'
      FreeTodayCoupon.create!(:user_id => 1).code.should == 'a'

      ActiveSupport::SecureRandom.should_receive(:base64).and_return 'a'
      ActiveSupport::SecureRandom.should_receive(:base64).and_return 'b'
      FreeTodayCoupon.create!(:user_id => 1).code.should == 'b'
    end
  end

  describe :redeem! do
    it "marks the coupon as redeemed" do
      coupon = FreeTodayCoupon.create!(:user_id => 1)
      coupon.should_not be_redeemed
      coupon.redeem!(2)
      coupon.should be_redeemed
    end
  end
end