require 'test_helper'

class DealTest < ActiveSupport::TestCase
  test "factory should be sane" do
    assert FactoryGirl.build(:deal).valid?
  end

  # I think this is a bad test and it fails sometimes
  test "over should honor current time" do
  	deal = FactoryGirl.create(:deal, :end_at => Time.zone.now + 1.minute)
  	assert !deal.over?, "Deal should not be over"

    Timecop.travel(Time.zone.now + 1.minute) do
      assert deal.over?, "Deal should be over"
    end
  end
end
