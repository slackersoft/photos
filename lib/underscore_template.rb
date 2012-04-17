class UnderscoreTemplate < Tilt::Template
  include ActionView::Helpers::JavaScriptHelper

  self.default_mime_type = 'application/javascript'
  self.engine_initialized = true

  def initialize_engine; end
  def prepare; end

  def evaluate(context, locals, &block)
    template_name = context.logical_path.gsub(/^templates\/(.*)$/, "\\1").to_s
    @output = <<-JS
(function (app) {
app.templates['#{template_name}'] = _.template("#{escape_javascript data}");
}(PhotosApp));
JS
  end
end
