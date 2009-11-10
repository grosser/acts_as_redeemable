Rails plugin that adds redemption capability to a model for items like coupons, invitation codes, etc.  
Each redeemable gets a unique code upon creation that can be sent in an email or printed as a coupon code.

Install
=======
    script/plugin install git://github.com/grosser/acts_as_redeemable.git

Usage
=====

### Optionally generate the model 
    script/generate redeemable Coupon
    rake db:migrate

### Make your ActiveRecord model act as redeemable.
    class Coupon < ActiveRecord::Base
      acts_as_redeemable :valid_for => 30.days, :code_length => 8 # optional expiration, code length
    end

### Redeem!

    c = Coupon.new
    c.user_id = 1 # The user who created the coupon
    c.save!

    c.code        # "4D9110A3"
    c.expires_at  # 30.days.from_now
    c.redeemed?   # false

    c.redeem!(current_user.id) # redeems unless expired or already redeemed
    c.redeemed?   # true

Authors
======

### Contributors
  - [cyu](http://github.com/cyu)
  - [Michael Grosser](http://pragmatig.wordpress.com)

Copyright (c) 2008 Squeejee, released under the MIT license