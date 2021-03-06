Fabricator :user do
  name 'Stefan'
  email 'info@stefanwienert.de'
  password 'password123'
  password_confirmation do |a, _|
    a[:password]
  end
  created_at { 1.year.ago }
  gdpr_consent_given_on { Time.zone.now }
end

Fabricator :generated_user, from: :user do
  name Faker::Name.name
  email Faker::Internet.email
end

Fabricator :challenge do
  type 'ExtensiveChallenge'
  title 'Spring Break 2014'
  from_date 1.day.ago
  to_date 15.days.from_now
  visible true
  goal_type :goal_time
  description ''
end

Fabricator :participation do
  challenge
  user
  goal_hours 60
end

Fabricator :reading_challenge, from: :challenge do
  goal_type :goal_unit
  unit_type
end
