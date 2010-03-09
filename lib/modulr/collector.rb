module Modulr
  class Collector
    attr_reader :modules, :main
    
    def initialize(root = nil)
      @root = root
      @modules = {}
    end
    
    def parse_file(path)
      @src = File.read(path)
      @root ||= File.dirname(path)
      @main = JSModule.new(File.basename(path, '.js'), @root, path)
      modules[main.id] = main
      collect_dependencies(main)
    end

    def collect_dependencies(js_module)
      js_module.dependencies.each do |dependency|
        unless modules[dependency.id]
          modules[dependency.id] = dependency
          collect_dependencies(dependency)
        end
      end
    end
    
    def to_js(buffer = '')
      buffer << File.read(PATH_TO_MODULR_JS);
      modules.each { |id, js_module| js_module.to_js(buffer) }
      buffer << "\nmodulr.require('#{main.identifier}');\n"
    end
  end
end