class UnderscoreTemplate < Tilt::Template
  self.default_mime_type = 'text/javascript'

  def self.engine_initialized?; true; end
  def initialize_engine; end
  def prepare; end

  def evaluate(context, locals, &block)
    template_name = Pathname.new(@file).sub_ext('').sub_ext('').basename.to_s
    @output = <<-JS
PhotosApp.templates['#{template_name}'] = _.template("#{@data.gsub('"', '\"').gsub("\n", "")}")
JS
  end
end
