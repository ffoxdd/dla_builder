require_relative "../app/dla.rb"
require_relative "./renderer.rb"

def setup
  size 800, 600
  background 0

  @dla = Dla.new { |particle| Renderer.new(self, particle).render }
end

def draw
  @dla.grow
end
