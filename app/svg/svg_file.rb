require_relative "svg"
require "rasem"

class SVG::File

  def initialize(filename:, dimensions:)
    @filename = filename
    @dimensions = dimensions
  end

  def save(&block)
    File.open(filename, 'w') { |file| svg_image(file, &block) }
  end

  private
  attr_reader :filename, :dimensions

  def svg_image(file, &block)
    Rasem::SVGImage.new(*dimensions.to_a, file).tap do |image|
      yield(image)
      image.close
    end
  end

end
