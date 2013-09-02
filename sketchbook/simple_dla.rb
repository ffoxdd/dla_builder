require File.join(File.dirname(__FILE__), "..", "app", "dla")
require File.join(File.dirname(__FILE__), "renderer")

def setup
  size 800, 600
  background 0

  @dla = Dla.new { |particle| Renderer.new(self, particle).render }
end

def draw
  @dla.grow
end
