require 'matrix'
require 'forwardable'

class Vector2D

  extend Forwardable

  def self.[](*elements)
    new(elements)
  end

  def self.random(magnitude)
    new(random_coordinates(magnitude))
  end

  def initialize(elements)
    @vector = Vector[*elements.to_a]
  end

  def_delegators :vector, :magnitude, :[], :to_a

  def ==(rhs)
    vector == rhs.vector
  end

  def +(rhs)
    Vector2D.new(vector + rhs.vector)
  end

  def -(rhs)
    Vector2D.new(vector - rhs.vector)
  end

  def *(rhs)
    # TODO: remove this nasty branch when homogeneous coordinates are implemented
    return Vector2D.new(vector * rhs) if rhs.respond_to?(:*)

    rotate(rhs.rotation) + rhs.translation
  end

  def -@
    self * -1
  end

  def map(&block)
    Vector2D.new(vector.map(&block))
  end

  def determinant(other_vector)
    Matrix[vector, other_vector.vector].determinant
  end

  def rotate(theta)
    Vector2D.new(Vector2D.rotation_matrix(theta) * vector)
  end

  def inner_product(other_vector)
    vector.inner_product(other_vector.vector)
  end

  def angle_to(other_vector)
    v = other_vector.to_v
    cosine_theta = inner_product(v) / (magnitude * v.magnitude)
    acos(cosine_theta)
  end

  def to_v
    self
  end

  def right_handed?(other_vector)
    determinant(other_vector.to_v) >= 0
  end

  def signed_angle_to(other_vector)
    angle_to(other_vector) * sign(other_vector)
  end

  def self.rotation_matrix(theta)
    Matrix[
      [Math.cos(theta), -Math.sin(theta)],
      [Math.sin(theta),  Math.cos(theta)]
    ]
  end

  protected

    attr_reader :vector

    TWO_PI = 2 * Math::PI

    def self.random_theta
      TWO_PI * rand
    end

    def self.random_coordinates(radius)
      theta = random_theta
      [Math.sin(theta) * radius, Math.cos(theta) * radius]
    end

    def sign(other_vector)
      right_handed?(other_vector) ? 1 : -1
    end

    def acos(x)
      Math.acos(clip(x, -1..1))
    end

    def clip(n, range)
      return range.begin if n < range.begin
      return range.end if n > range.end
      n
    end

end
