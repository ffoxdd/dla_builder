require_relative "../svg/svg_file"

class PointCloudSVGFile

  def initialize(point_cloud, filename: "data/point_cloud.svg")
    @point_cloud = point_cloud
    @filename = filename
  end

  def save
    svg_file.save { |image| draw(image) }
  end

  private
  attr_reader :point_cloud, :filename

  def draw(image)
    point_cloud.points.each { |point| draw_point(point, image) }
  end

  def draw_point(point, image, stroke: "black")
    image.circle(*coordinates(point), 2, stroke: stroke)
  end

  def svg_file
    @svg_file ||= SVG::File.new(filename: filename, dimensions: dimensions)
  end

  def border_offset
    @border_offset ||= Vector2D[BORDER, BORDER]
  end

  def in_svg_coordinate_system(point)
    point - point_cloud.origin + border_offset
  end

  def coordinates(point)
    in_svg_coordinate_system(point).to_a
  end

  BORDER = 10

  def dimensions
    @dimensions ||= point_cloud.size.map { |side_length| side_length + BORDER * 2}
  end

end
