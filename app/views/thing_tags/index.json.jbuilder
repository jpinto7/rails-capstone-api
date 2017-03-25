json.array!(@thing_tags) do |t|
  json.extract! t, :id, :name unless !@current_user
end
