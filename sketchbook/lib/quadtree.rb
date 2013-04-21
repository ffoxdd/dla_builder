class Quadtree

  def initialize(x_range, y_range, options = {})
    raise ArgumentError, "invalid range" unless valid_ranges?(x_range, y_range)

    @x_range = x_range
    @y_range = y_range
    @max_depth = options[:max_depth] || 10
    @particles = []
    @children = []
  end

  def size
    leaf? ? particles.size : children.map(&:size).inject(&:+)
  end

  def add(particle)
    return unless covers?(particle)
    subdivide if leaf? && can_subdivide?
    leaf? ? particles.push(particle) : child_for(particle).add(particle)
  end

  def covers?(particle)
    x_range.cover?(particle.x) && y_range.cover?(particle.y)
  end

  def within(test_x_range, test_y_range)
    if leaf?
      @particles.select do |particle|
        test_x_range.cover?(particle.x) && test_y_range.cover?(particle.y) # particle#within? would be better
      end
    else
      children.flat_map { |child| child.within(test_x_range, test_y_range) }
    end
  end

  def depth
    return 0 if leaf?
    children.map(&:depth).max + 1
  end

  private

  attr_reader :x_range, :y_range, :particles, :max_depth, :children

  def child_for(particle)
    children[child_index_for(particle)]
  end

  def child_index_for(particle)
    (particle.x >= midpoint(x_range) ? 1 : 0) + (particle.y >= midpoint(y_range) ? 2 : 0)
  end

  def can_subdivide?
    depth < max_depth
  end

  def subdivide
    x_ranges = subdivide_range(x_range)
    y_ranges = subdivide_range(y_range)
    child_options = {:max_depth => max_depth - 1}

    children[0] = Quadtree.new(x_ranges[0], y_ranges[0], child_options)
    children[1] = Quadtree.new(x_ranges[1], y_ranges[0], child_options)
    children[2] = Quadtree.new(x_ranges[0], y_ranges[1], child_options)
    children[3] = Quadtree.new(x_ranges[1], y_ranges[1], child_options)
  end

  def subdivide_range(range)
    midpoint = midpoint(range)
    [range.begin...midpoint, midpoint...range.end]
  end

  def midpoint(range)
    length = range.end - range.begin
    range.begin + (length / 2.0)
  end

  def leaf?
    children.empty?
  end

  def valid_ranges?(*args)
   ranges?(*args) && open_ended?(*args)
  end

  def ranges?(*args)
    args.all? { |arg| arg.is_a?(Range) }
  end

  def open_ended?(*args)
    args.all?(&:exclude_end?)
  end

end
