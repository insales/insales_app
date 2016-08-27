OptionNamesMapper = Struct.new(:option_name) do
  def params
    {
      insales_option_id: option_name.id,
      position: option_name.position,
      title: option_name.title
    }
  end
end
