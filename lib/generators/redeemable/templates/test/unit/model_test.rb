require File.dirname(__FILE__) + '/../test_helper'

class <%= class_name %>Test < Test::Unit::TestCase
  fixtures :<%= file_name.pluralize %>

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
