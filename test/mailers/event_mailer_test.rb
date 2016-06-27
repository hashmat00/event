require 'test_helper'

class EventMailerTest < ActionMailer::TestCase
  test "contact_email" do
    mail = EventMailer.contact_email
    assert_equal "Contact email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
