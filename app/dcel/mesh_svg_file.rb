require_relative "dcel"
require 'rasem'

class DCEL::MeshSVGFile

  def initialize( mesh,
    filename: "data/mesh.svg",
    bounds: calculate_bounds(mesh),
    highlighted_faces: [], highlighted_vertices: [] )

    @mesh = mesh
    @bounds = bounds
    @filename = filename
    @highlighted_faces = highlighted_faces
    @highlighted_vertices = highlighted_vertices
  end

  def save
    File.open(filename, 'w') { |f| svg_image(f) }
  end

  private
  attr_reader :mesh, :filename, :bounds, :highlighted_faces, :highlighted_vertices

  def svg_image(file)
    new_svg_image(file) { |image| draw_mesh(image) }
  end

  def new_svg_image(file, &block)
    Rasem::SVGImage.new(*dimensions.to_a, file).tap do |image|
      yield(image)
      image.close
    end
  end

  def draw_mesh(image)
    draw_edges(image)
    draw_vertices(image)
    draw_faces(image)
  end

  def draw_edges(image)
    mesh.edge_enumerator.each { |edge| draw_edge(edge, image) }
  end

  def draw_faces(image)
    highlighted_faces.each { |face| draw_face(face, image) }
  end

  def draw_vertices(image)
    highlighted_vertices.each { |vertex| draw_vertex(vertex, image) }
  end

  def draw_face(face, image, fill: "red")
    image.polygon(*coordinates(face.vertex_value_enumerator), fill: fill)
  end

  def draw_edge(edge, image, stroke: "black")
    stroke = "red" if edge.has_property?(:hidden, true)
    image.line(*coordinates(edge.vertices), stroke: stroke)
  end

  def draw_vertex(vertex, image, stroke: "orange")
    image.circle(*coordinates(vertex), 5, stroke: stroke)
  end

  def coordinates(vertices)
    Array(vertices).map { |vertex| t(vertex.value.to_a) }.flatten
  end

  def t(coordinates)
    [
      coordinates[0] - bounds[0].first + BORDER,
      coordinates[1] - bounds[1].first + BORDER
    ]
  end

  BORDER = 10

  def dimensions
    @dimensions ||= bounds.map { |min, max| max - min + (BORDER * 2) }
  end

  def calculate_bounds(mesh)
    [bounds_by(mesh, &:x), bounds_by(mesh, &:y)]
  end

  def bounds_by(mesh, &value)
    mesh.vertex_value_enumerator.map(&value).minmax
  end

end
