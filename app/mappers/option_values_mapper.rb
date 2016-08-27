OptionValuesMapper = Struct.new(:option_value) do
  def params
    {
      insales_option_value_id: option_value.id,
      insales_option_id: option_value.option_name_id,
      position: option_value.position,
      title: option_value.title
    }
  end
end
