class BoundingBoxFinder

  def initialize(convex_hull)
    @convex_hull = convex_hull
  end

  def bounding_box
    return if convex_hull.empty? || convex_hull.singleton?
  end

  private

    attr_reader :convex_hull

end
