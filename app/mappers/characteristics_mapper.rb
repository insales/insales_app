CharacteristicsMapper = Struct.new(:characteristic) do
  def params
    {
      insales_characteristics_id: characteristic.id,
      insales_property_id: characteristic.property_id,
      position: characteristic.position,
      permalink: characteristic.permalink,
      title: characteristic.title
    }
  end
end
