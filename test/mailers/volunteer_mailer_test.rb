require "test_helper"

class VolunteerMailerTest < ActionMailer::TestCase
  test "opportunity_expiry" do
    mail = VolunteerMailer.opportunity_expiry
    assert_equal "Opportunity expiry", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
