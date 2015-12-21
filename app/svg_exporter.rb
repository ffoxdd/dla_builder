require_relative "vector2d"
require 'rasem'
require "forwardable"

require 'pry'

class SvgExporter

  def initialize(dla, filename = "dla.svg")
    @dla = dla
    @filename = filename
  end

  def export
    File.open(filename, 'w') { |f| f << svg_image(f).output }
  end

  private
  attr_reader :dla, :filename

  def particles; dla.accept.map; end # TEMP

  def svg_image(file)
    new_svg_image(file) { |image| draw_particles(image) }
  end

  def new_svg_image(file, &block)
    Rasem::SVGImage.new(*dimensions.to_a, file).tap do |image|
      yield(image)
      image.close
    end
  end

  def draw_particles(image)
    dla.accept { |particle| draw_particle(particle, image) }
  end

  def draw_particle(particle, image)
    image.circle *coordinates(particle), particle.radius
  end

  def dla_dimensions_finder
    @dla_dimensions_finder ||= DlaDimensionsFinder.new(dla)
  end

  extend Forwardable
  def_delegators :dla_dimensions_finder, :dimensions, :center_offset

  def coordinates(particle)
    (particle.to_v + center_offset).to_a
  end

  class DlaDimensionsFinder # TODO: this needs to be implemented somewhere else
    def initialize(dla)
      @dla = dla
    end

    def dimensions
      @dimensions ||= Vector2D.new( minmax.map { |m| measure(m) })
    end

    def center_offset
      @center_offset ||= dimensions * 0.5
    end

    private
    attr_reader :dla

    def center
      dimensions * 0.5
    end

    def flip_y_axis(vector)
      Vector2D[vector[0], vector[1] * -1]
    end

    def particles # TODO: consider opening up the usual enumerable methods
      @particles ||= dla.accept.map
    end

    def minmax
      [particles.map(&:x).minmax, particles.map(&:y).minmax]
    end

    # def origin
    #   Vector2D.new( minmax.map(&:first) )
    # end

    def measure(interval)
      interval[1] - interval[0]
    end
  end

end
