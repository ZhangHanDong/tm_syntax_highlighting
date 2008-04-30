css_path = File.join(File.dirname(__FILE__), "generators", "syntax_css", "templates", "stylesheets", "syntax")
FileUtils.mkdir_p(css_path)

Dir.glob(File.join(Uv.path, "render", "xhtml", "files", "css", "*.css")) do |css|
  FileUtils.cp(css, css_path)
end