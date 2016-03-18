require 'matrix'
require 'forwardable'
require_relative 'vector2d'

class Point

  extend Forwardable

  def self.[](*coordinates)
    new(coordinates)
  end

  def self.random(radius)
    new(Vector2D.random(radius))
  end

  def initialize(coordinates)
    @vector = Vector2D[*coordinates]
  end

  def x
    vector[0]
  end

  def y
    vector[1]
  end

  def_delegators :vector, :[], :magnitude, :to_a, :hash, :inner_product

  def +(offset)
    Point.new(vector + offset.to_v)
  end

  def -(offset)
    Point.new(vector - offset.to_v)
  end

  def ==(point)
    vector == point.vector
  end

  alias_method :eql?, :==

  def map(&block)
    Point.new(vector.map(&block))
  end

  def displacement(point)
    point.to_v - vector
  end

  def distance(point)
    displacement(point).magnitude
  end

  def extent
    Point.new(vector.map(&:abs))
  end

  def max(rhs)
    Point.new(to_a.zip(rhs.to_a).map(&:max))
  end

  def rotate(theta)
    Point.new(vector.rotate(theta))
  end

  def determinant(v1)
    vector.determinant(v1.vector)
  end

  def inspect
    "Point[#{x}, #{y}]"
  end

  def to_v
    vector
  end

  def *(transformation)
    Point.new(vector.transform(transformation))
  end

  protected
  attr_reader :vector

end
