Fabricator :user do
  name 'Stefan'
  email 'info@stefanwienert.de'
  password 'password123'
  password_confirmation do |a,b|
    a[:password]
  end
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

Fabricator :reading_challenge, from: :challenge do
  goal_type :goal_unit
  unit 'pages'
end
