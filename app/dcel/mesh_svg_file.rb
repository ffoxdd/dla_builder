require_relative "dcel"
require 'rasem'

class DCEL::MeshSVGFile

  def initialize(mesh, filename: "data/mesh.svg", highlighted_faces: [], highlighted_vertices: [])
    @mesh = mesh
    @filename = filename
    @highlighted_faces = highlighted_faces
    @highlighted_vertices = highlighted_vertices
  end

  def save
    File.open(filename, 'w') { |f| svg_image(f) }
  end

  private
  attr_reader :mesh, :filename, :highlighted_faces, :highlighted_vertices

  def svg_image(file)
    new_svg_image(file) { |image| draw_mesh(image) }
  end

  def dimensions
    [500, 500]
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
    coordinates = face.vertex_value_enumerator.map { |point| t(point.to_a) }
    image.polygon(coordinates, fill: fill)
  end

  def draw_edge(edge, image, stroke: "black")
    stroke = "red" if edge.has_property?(:hidden, true)

    vertices = edge.vertices
    coordinates = vertices.flat_map { |vertex| vertex.value.to_a }
    image.line(*t(coordinates), stroke: stroke)
  end

  def draw_vertex(vertex, image, stroke: "orange")
    image.circle(*t(vertex.value.to_a), 5, stroke: stroke)
  end

  def t(coordinates)
    coordinates.map { |n| n + dimensions.first / 2 }
  end

end
