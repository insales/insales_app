ImagesMapper = Struct.new(:image) do
  def params
    {
      insales_image_id: image.id,
      insales_created_at: image.created_at,
      position: image.position,
      original_url: image.original_url,
      title: image.title,
      filename: image.filename
    }
  end
end
