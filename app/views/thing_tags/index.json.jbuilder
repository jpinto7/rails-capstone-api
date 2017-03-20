json.array!(@thing_tags) do |t|
  json.extract! t, :id, :name, :created_at, :updated_at
end
