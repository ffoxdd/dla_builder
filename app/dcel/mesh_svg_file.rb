require 'rasem'

module DCEL; end

class DCEL::MeshSVGFile

  def initialize(mesh, filename = "mesh.svg")
    @mesh = mesh
    @filename = filename
  end

  def save
    File.open(filename, 'w') { |f| svg_image(f) }
  end

  private
  attr_reader :mesh, :filename

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
    # draw_vertices(image)
  end

  def draw_edges(image)
    mesh.edge_enumerator.each { |edge| draw_edge(edge, image) }
  end

  def draw_vertices(image)
    mesh.vertex_enumerator.each { |vertex| draw_vertex(vertex, image) }
  end

  def draw_edge(edge, image, stroke: "black")
    vertices = edge.vertices
    coordinates = vertices.flat_map { |vertex| vertex.value.to_a }
    image.line(*t(coordinates), stroke: stroke)
  end

  def draw_vertex(vertex, image, stroke: "black")
    image.circle(*t(vertex.value.to_a), 5, stroke: stroke)
  end

  def t(coordinates)
    coordinates.map { |n| n + dimensions.first / 2 }
  end

end
