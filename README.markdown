### Branch of acts_as_redeemable to:
 - add tests
 - remove unused :recipient_id
 - use [ReadableRandom](http://github.com/grosser/readable_random) to generate codes (readable + non-insulting)
 - use :expires_at (Rails default for times, still supports :expires_on)
 - rename from Squeejee::Acts::Redeemable to ActsAsRedeemable
 - add a nice Readme
 - refactor


Rails plugin that adds redemption capability to a model for items like coupons, invitation codes, etc.
Each redeemable gets a unique code upon creation that can be sent in an email or printed as a coupon code.

Install
=======
    sudo gem install readable_random
    script/plugin install git://github.com/grosser/acts_as_redeemable.git

Usage
=====

### Generate model and migrations (or do it by hand...)
    # columns needed: code, user_id, expired_at, redeemed_at, redeemed_by_id
    script/generate redeemable Coupon
    rake db:migrate

### Add act_as_redeemable
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
  - [cyu](http://blog.codeeg.com)
  - [Michael Grosser](http://pragmatig.wordpress.com)

Copyright (c) 2008 Squeejee, released under the MIT license