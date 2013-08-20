require File.join(File.dirname(__FILE__), "..", "app", "dla")

NAME_ROOT = "canvas_60in-40in-5mm"

def setup
  size 875, 700
  background 0

  @index = 0
  @renderer = Renderer.new
end

def draw
end

def keyPressed
  draw_dla
  next_dla
end

def write_text(text_string, line)
  fill(rgb(255, 100, 100))
  textSize(18)
  textAlign(LEFT, TOP)

  text(text_string, 0, 20 * line)
end

def draw_dla
  clear_screen

  dla = current_dla
  dla.renderer = @renderer
  dla.render

  write_text("name: #{current_name}", 0)
  write_text("particles: #{dla.size}", 1)
end

def clear_screen
  fill(0)
  rect(0, 0, width, height)
end

def next_dla
  @index = (@index + 1) % run_numbers.size
end

def current_dla
  Persister.read(current_name)
end

def current_name
  name(run_numbers[@index])
end

def name(number)
  "#{NAME_ROOT}_#{number}"
end

def run_numbers
  @run_numbers ||= filenames.map { |filename| filename.match(/\d{3}/)[0] }
end

def filenames
  Dir.glob("./data/#{NAME_ROOT}*")
end

def run_numbers
  Dir.glob("./data/#{NAME_ROOT}*").map { |filename| filename.match(/\d{3}/)[0] }
end

class Renderer

  def render(particle)
    settings
    ellipse x(particle), y(particle), particle.radius, particle.radius
  end

  private

  def settings
    noStroke
    smooth
    ellipseMode(RADIUS)
    fill(255)
  end

  def x(particle)
    x_origin + particle.x
  end

  def y(particle)
    y_origin + particle.y
  end

  def x_origin
    @x_origin ||= width / 2
  end

  def y_origin
    @y_origin ||= height / 2
  end
  
end
