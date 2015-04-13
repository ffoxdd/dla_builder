require_relative "../test_helper.rb"
require_relative "../../app/vertices_bounding_box_builder.rb"

describe VerticesBoundingBoxBuilder do
  describe ".bounding_box" do
    it "builds a bounding box from the locations of its four corners" do
      points = [Point[1, 1], Point[0, 0], Point[-1, 1], Point[0, 2]]
      bounding_box = VerticesBoundingBoxBuilder.bounding_box(points)

      vertices = bounding_box.vertices

      # TODO: clean up with a within_delta matcher for bounding_boxes
      vertices[0].distance(points[0]).must_be_close_to 0, 1e-10
      vertices[1].distance(points[1]).must_be_close_to 0, 1e-10
      vertices[2].distance(points[2]).must_be_close_to 0, 1e-10
      vertices[3].distance(points[3]).must_be_close_to 0, 1e-10
    end

    it "works with vertices indicated in the opposite direction" do
      points = [Point[0, 2], Point[-1, 1], Point[0, 0], Point[1, 1]]
      bounding_box = VerticesBoundingBoxBuilder.bounding_box(points)

      vertices = bounding_box.vertices
      # TODO: implement with a within_delta matcher for bounding boxes
    end

    it "works in the case, lol" do
      points = [Point[-1.0, 1.0], Point[1.0, 1.0], Point[1.0, 0.0], Point[-1.0, -0.0]]
      bounding_box = VerticesBoundingBoxBuilder.bounding_box(points)

      vertices = bounding_box.vertices
      # TODO: implement with a within_delta matcher for bounding boxes
    end
  end
end
