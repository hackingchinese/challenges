class UsersGrid < BaseGrid
  scope do
    User.order('last_sign_in_at is null, last_sign_in_at desc').includes(:account_connections, :mail_preference)
  end

  filter(:email, :string) { |value| where("email ilike ?", "%#{value}%") }
  filter(:name, :string) { |value| where("name ilike ?", "%#{value}%") }
  filter(:blocked, :xboolean)

  column :name, html: true do |u|
    link_to user_path(u) do
      u.name
    end
  end
  column :email, html: true do |user|
    out = []
    out += user.account_connections.map(&:provider).map do |prov|
      content_tag(:i, nil, class: "fa fa-fw fa-#{prov}")
    end
    out << user.email
    safe_join(out)
  end
  column :gets_mail do |user|
    !(user.fake_email?) && (user.mail_preference.challenge_started == '1' || user.mail_preference.challenge_starts_soon == '1') ? "Yes" : "No"
  end
  date_column :last_sign_in_at
  column(:actions, html: true) do |user|
    links = []
    if user.mail_preference.any?
      links << link_to(admin_user_path(user, disable_email: 1), data: { method: :patch, remote: true }, class: 'btn btn-sm btn-outline-primary') do
        "disable email"
      end
    end
    links << link_to([:admin, user], data: { method: :delete, confirm: "Do you really want to delete the user?", remote: true }, class: 'btn btn-sm btn-outline-danger') do
      'delete'
    end
    if user.blocked?
      links << link_to("Unblock", [:unblock, :admin, user], data: { method: :post }, class: 'btn btn-sm btn-outline-danger')
    else
      links << link_to("Block/Hide", [:block, :admin, user], data: { method: :post }, class: 'btn btn-sm btn-outline-danger')
    end
    content_tag(:div, safe_join(links), class: 'btn-group')
  end
end
