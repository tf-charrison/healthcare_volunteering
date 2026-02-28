# config/schedule.rb

# Run the job every day at 9am
every 1.day, at: '9:00 am' do
  runner "OpportunityExpiryJob.perform_later"
end