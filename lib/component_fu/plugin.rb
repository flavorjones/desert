module ComponentFu
  class Plugin
    attr_reader :name, :path
    def initialize(path)
      @path = File.expand_path(path)
      @name = File.basename(@path)
    end

    def migration_path
      "#{@path}/db/migrate"
    end

    # The path to the views for this plugin
    def templates_path
      "#{@path}/app/views"
    end

    # The path to the layout for this plugin
    def layouts_path
      "#{templates_path}/layouts"
    end

    # Finds a template with the specified path
    def find_template(template)
      path = "#{templates_path}/#{template}"
      File.exists?(path) ? path : nil
    end    

    def ==(other)
      self.path == other.path
    end
  end
end