require_relative "../app/dla.rb"
require_relative "./renderer.rb"

NAME_ROOT = "canvas_60in-48in-10mm"

require 'pry'

def setup
  size 875, 700
  background 0

  @index = 0
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

  dla.visitor = lambda do |particle|
    Renderer.new(self, particle).render
  end

  dla.accept

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
