require 'matrix'
require 'forwardable'

class Point

  extend Forwardable

  def initialize(x, y)
    @x = Float(x)
    @y = Float(y)

    @vector = Vector[@x, @y]
  end

  attr_reader :x, :y
  def_delegators :vector, :[], :magnitude

  def self.from_vector(vector)
    new(*vector.to_a)
  end

  def self.random(radius)
    new(*random_coordinates(radius))
  end

  def +(point)
    Point.from_vector(vector + point.vector)
  end

  def -(point)
    Point.from_vector(vector - point.vector)
  end

  def ==(point)
    vector == point.vector
  end

  def distance(point)
    (self - point).magnitude
  end

  def extent
    Point.from_vector(vector.map(&:abs))
  end

  def max(point)
    Point.new([x, point.x].max, [y, point.y].max)
  end

  def rotate(theta)
    Point.from_vector(rotation_matrix(theta) * vector)
  end

  def determinant(v1)
    Matrix[vector, v1.vector].determinant
  end

  def left_of?(edge)
    v0 = edge[1] - edge[0]
    v1 = self - edge[0]

    v0.determinant(v1) > 0
  end

  protected

    attr_reader :vector

  private

    TWO_PI = 2 * Math::PI

    def rotation_matrix(theta)
      Matrix[[Math.cos(theta), -Math.sin(theta)], [Math.sin(theta), Math.cos(theta)]]
    end

    def self.random_theta
      TWO_PI * rand
    end

    def self.random_coordinates(radius)
      theta = random_theta
      [Math.sin(theta) * radius, Math.cos(theta) * radius]
    end

end
