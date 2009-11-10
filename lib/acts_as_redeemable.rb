require 'activerecord'
require 'readable_random'

module ActsAsRedeemable
  def self.included(base)
    base.extend ClassMethods
  end

  # This act provides the capabilities for redeeming and expiring models. Useful for things like
  # coupons, invitations, and special offers.
  #
  # Coupon example:
  #
  #   class Coupon < ActiveRecord::Base
  #     acts_as_redeemable :valid_for => 30.days, :code_length => 8 # optional expiration, code length
  #   end
  #
  #
  #   c = Coupon.new
  #   c.user_id = 1 # The user who created the coupon
  #   c.save
  #   c.code
  #
  #   # "4D9110A3"
  module ClassMethods
    # Configuration options are:
    #
    # * +valid_for+ - specifies the duration until redeemable expire. Default is no expiration
    # * +code_length+ - set the length of the generated unique code. Default is six alphanumeric characters
    # * example: <tt>acts_as_redeemable :valid_for => 30.days, :code_length => 8</tt>
    def acts_as_redeemable(options = {})
      unless redeemable? # don't let AR call this twice
        cattr_accessor :valid_for
        cattr_accessor :code_length
        before_create :initialize_redeemable
        self.valid_for = options[:valid_for] unless options[:valid_for].nil?
        self.code_length = (options[:code_length].nil? ? 6 : options[:code_length])
      end
      include InstanceMethods

      # Generates unique code based on +generate_code+ method
      def generate_unique_code
        begin
          new_code = ReadableRandom.get(self.code_length)
        end until !active_code?(new_code)
        new_code
      end

      # Checks the database to ensure the specified code is not taken
      def active_code?(code)
        find :first, :conditions => {:code => code}
      end
    end

    def redeemable? #:nodoc:
      self.included_modules.include?(InstanceMethods)
    end
  end

  module InstanceMethods
    # Marks the redeemable redeemed by the given user id
    # * +redeemed_by_id+ - id of redeeming user
    def redeem!(redeemed_by_id)
      return if redeemed? or expired?
      update_attributes :redeemed_by_id => redeemed_by_id, :redeemed_at => Time.now
      after_redeem
    end

    # Returns whether or not the redeemable has been redeemed
    def redeemed?
      self.redeemed_at?
    end

    # Returns whether or not the redeemable has expired
    def expired?
      time = respond_to?(:expires_on) ? expires_on : expires_at
      time and time < Time.now
    end

    def initialize_redeemable
      # set code
      self.code = self.class.generate_unique_code

      # set expiration
      field = respond_to?(:expires_on) ? :expires_on : :expires_at
      return if not self.class.valid_for or send(field)
      send "#{field}=", self.class.valid_for.from_now
    end

    # Callback for business logic to implement after redemption
    def after_redeem() end
  end
end

ActiveRecord::Base.send(:include, ActsAsRedeemable)