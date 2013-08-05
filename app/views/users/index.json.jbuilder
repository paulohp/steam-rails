json.array!(@users) do |user|
  json.extract! user, :name, :uid, :provider
  json.url user_url(user, format: :json)
end
