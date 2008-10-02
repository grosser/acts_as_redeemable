require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment.rb'))
require File.dirname(__FILE__) + '/../lib/acts_as_redeemable'
load(File.dirname(__FILE__) + "/schema.rb")

class FreeTodayCoupon < ActiveRecord::Base
  acts_as_redeemable
  
end

class ActsAsRedeemableTest < Test::Unit::TestCase
  def setup
    @coupon = FreeTodayCoupon.create(:user_id => 1)  
  end
  
  def many_codes(num=100)
    codes = []
    num.times {codes << FreeTodayCoupon.generate_code}
    codes
  end
  
  #CODE
  def test_code_has_correct_length
    assert_equal 6, FreeTodayCoupon.generate_unique_code.length
    assert_equal 6, @coupon.code.length 
  end
  
  def test_code_does_not_contain_0_or_O
    codes = many_codes
    assert_equal nil, codes.detect {|c|c.include?('0')}
    assert_equal nil, codes.detect {|c|c.include?('O')}
  end
  
  def test_code_is_not_insulting
    
  end
  
  def test_code_is_random
    assert_equal 100, many_codes(100).uniq.size
  end
  
  #REDEEM
  def test_should_mark_redeemed
    @coupon.redeem!(2)
    assert @coupon.redeemed?
  end
  
  def test_stores_redeemed_by_id_on_redeem
    @coupon.redeem!(2)
    assert_equal 2,@coupon.redeemed_by_id
  end
  
  def test_should_set_redeemed_at
    @coupon.redeem!(2)
    assert_equal Time.now.to_s,@coupon.redeemed_at.to_s
  end
  
  #EXPIRE
  def test_not_expired_when_not_set
    @coupon.expires_at = nil
    assert !@coupon.expired?
  end
  
  def test_expired_when_time_greater_expires_at
    @coupon.expires_at = 1.second.ago
    assert @coupon.expired?
    @coupon.expires_at = 2.seconds.from_now
    assert !@coupon.expired?
  end
  
end
