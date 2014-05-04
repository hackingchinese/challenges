puts "Loading seeds..."
User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
  user.password = Rails.application.secrets.admin_password
  user.password_confirmation = Rails.application.secrets.admin_password
  user.confirm! rescue false
end



challenge = Challenge.create! "title"=>"Hackingchinese Reading Challenge 2014",
  "from_date"=> 27.days.ago,
  "to_date"=>23.days.from_now,
  "type"=>"ExtensiveChallenge",
  "visible"=>true,
  "goal_type"=> 'goal_unit',
  "unit"=>"movies",
  "description"=> <<DOC
### Goal

Reading stuff for a month

### Prices

Awarded by ... 2 month trial for blahrg
DOC

dates =  (27.days.ago.to_date..Date.today).to_a

40.times do
  user = User.create!(email: Faker::Internet.email) do |u|
    u.name = Faker::Internet.user_name
    u.profile_link = Faker::Internet.url
    u.password = 'password123'
    u.password_confirmation = 'password123'
    u.confirm! rescue false
  end
  participation = challenge.participations.create! user_id: user.id, goal_units: rand(10..200)

  local_dates = dates.shuffle
  rand(0..27).times do
    units = rand(1..15)
    reported_minutes = rand() < 0.5 ? rand((units * 2)..(units * 10)) : nil
    comment = rand() < 0.2 ?  Faker::Lorem.paragraph(1) : nil
    ActivityLog.create! participation_id: participation.id, user_id: user.id, units_accomplished: units, created_at: local_dates.shift, minutes: reported_minutes, comment: comment
  end
end
