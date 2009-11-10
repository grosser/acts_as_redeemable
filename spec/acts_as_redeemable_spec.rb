require 'spec/spec_helper'

describe ActsAsRedeemable do
  describe :generate_unique_code do
    it "generates a 6 digit code by default" do
      FreeTodayCoupon.generate_unique_code.length.should == 6
    end
  end

  describe :redeem! do
    it "marks the coupon as redeemed" do
      coupon = FreeTodayCoupon.create(:user_id => 1)
      coupon.should_not be_redeemed
      coupon.redeem!(2)
      coupon.should be_redeemed
    end
  end
end