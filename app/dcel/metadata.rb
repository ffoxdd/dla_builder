require_relative "dcel"

module DCEL::Metadata

  def get_property(property)
    metadata_properties[property]
  end

  def set_property(property, value)
    metadata_properties[property] = value
  end

  def has_property?(property, value)
    get_property(property) == value
  end

  private

  def metadata_properties
    @metadata_properties ||= {}
  end

end
