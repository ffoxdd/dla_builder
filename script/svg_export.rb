require_relative "../app/dla_builder"
require_relative "../app/svg_exporter"

module Script; end

class Script::SvgExport
  def perform
    SvgExporter.new(dla, "dla.svg").export
  end

  private

  def dla
    @dla ||= DlaBuilder.new(limit: 10).build
  end
end

Script::SvgExport.new.perform
