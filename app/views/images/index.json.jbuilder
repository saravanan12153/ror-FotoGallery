json.array!(@images) do |image|
  json.extract! image, :id, :avatar
  json.url image_url(image, format: :json)
end
