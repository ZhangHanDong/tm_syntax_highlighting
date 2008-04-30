class SyntaxCssGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      theme = args[0]
      css_files = []
      Dir.glob(File.join(source_path("stylesheets/syntax"), "*.css")) do |css|
        css_files << File.basename(css)
      end
      
      
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
    end
  end
  
  protected
  def banner
    puts "Copies Syntax CSS files to public/stylesheets/syntax/\n\n"
  end  
  
  def usage_message
    puts "Usage: #{$0} syntax_css [all | list | theme_name]"
  end
end