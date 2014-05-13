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

  def map(&block)
    Vector2D.new(vector.map(&block))
  end

  def determinant(v1)
    Matrix[vector, v1.vector].determinant
  end

  def rotate(theta)
    Vector2D.new(rotation_matrix(theta) * vector)
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

    def rotation_matrix(theta)
      Matrix[
        [Math.cos(theta), -Math.sin(theta)],
        [Math.sin(theta),  Math.cos(theta)]
      ]
    end

end
