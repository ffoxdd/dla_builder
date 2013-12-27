class Canvas

  def initialize(viewport_dimensions, canvas_dimensions)
    @viewport_dimensions = viewport_dimensions # pixels
    @canvas_dimensions = canvas_dimensions # inches 
  end

  def sketch_dimensions
    canvas_dimensions.map { |inches| inches_to_pixels(inches) }
  end

  def mm_to_pixels(mm)
    inches_to_pixels(mm_to_inches(mm))
  end

  private

    attr_reader :viewport_dimensions, :canvas_dimensions

    MM_PER_IN = 25.4

    def mm_to_inches(mm)
      mm / MM_PER_IN
    end

    def inches_to_pixels(inches)
      inches * pixels_per_inch
    end

    def pixels_per_inch
      pixels.to_f / inches.to_f
    end

    def pixels
      viewport_dimensions[limiting_dimension]
    end

    def inches
      canvas_dimensions[limiting_dimension]
    end

    def limiting_dimension
      canvas_aspect_ratio > viewport_aspect_ratio ? 0 : 1
    end

    def viewport_aspect_ratio
      aspect_ratio(viewport_dimensions)
    end

    def canvas_aspect_ratio
      aspect_ratio(canvas_dimensions)
    end

    def aspect_ratio(dimensions)
      dimensions[0].to_f / dimensions[1].to_f
    end

end
