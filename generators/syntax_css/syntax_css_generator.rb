class SyntaxCssGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      theme = args[0]
      copy_css_from_uv
      css_files = css_from_templates
      
      if theme == "all"
        m.directory("public/stylesheets/syntax")      
        css_files.each do |css|
          m.file("stylesheets/syntax/#{css}", "public/stylesheets/syntax/#{css}")
        end
      elsif theme == "list"
        puts css_files.collect{|f| File.basename(f, ".css")}.sort.join("\n")
      else
        css = css_files.detect do |s|
          s =~ /^#{theme}\.css$/
        end
        if css
          m.directory("public/stylesheets/syntax")
          m.file("stylesheets/syntax/#{css}", "public/stylesheets/syntax/#{css}")
        else
          usage_message
          puts "Could not find theme named #{theme}."
        end
      end
      delete_css_files_from_template
    end
  end
  
  protected
  def banner
    puts "Copies Syntax CSS files to public/stylesheets/syntax/\n\n"
  end  
  
  def usage_message
    puts "Usage: #{$0} syntax_css [all | list | theme_name]"
  end
  
  def copy_css_from_uv
    puts "Copying CSS files from Ultraviolet"
    css_path = File.join(File.dirname(__FILE__), "templates", "stylesheets", "syntax")
    FileUtils.mkdir_p(css_path)

    Dir.glob(File.join(Uv.path, "render", "xhtml", "files", "css", "*.css")) do |css|
      FileUtils.cp(css, css_path)
    end
  end
  
  def delete_css_files_from_template
    css_from_templates.each do |file|
      FileUtils.rm(source_path("stylesheets/syntax/#{file}"))
    end
  end
  
  def css_from_templates
    css = []
    Dir.glob(File.join(source_path("stylesheets/syntax"), "*.css")) do |css|
      css << File.basename(css)
    end
    css
  end
end