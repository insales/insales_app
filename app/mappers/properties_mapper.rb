PropertiesMapper = Struct.new(:property) do
  def params
    {
      insales_property_id: property.id,
      backoffice: property.backoffice,
      is_hidden: property.is_hidden,
      is_navigational: property.is_navigational,
      position: property.position,
      permalink: property.permalink,
      title: property.title
    }
  end
end
