require_relative "builder"

module DCEL; end

class DCEL::Mesh

  def initialize(options = {})
    @faces = options.fetch(:faces, [])
    @edges = @faces.flat_map(&:edges)
    @vertices = @faces.flat_map(&:vertices)
  end

  def self.triangle(vertices)
    triangle_face = DCEL::Builder.triangle(vertices)
    new(faces: [triangle_face])
  end

  attr_reader :faces, :edges, :vertices

end
