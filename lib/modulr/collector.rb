module Modulr
  class Collector
    attr_reader :modules, :top_level_modules
    
    def initialize(options = {})
      @root = options[:root]
      @lazy_eval = options[:lazy_eval]
      @modules = []
      @top_level_modules = []
    end
    
    def parse_file(path)
      parse_files(path)
    end
    
    def parse_files(*paths)
      reset
      paths.each do |path|
        add_module_from_path(path)
      end
    end
    
    def reset
      modules.clear
      top_level_modules.clear
    end
    private :reset
    
    def module_from_path(path)
      identifier = File.basename(path, '.js')
      root = @root || File.dirname(path)
      JSModule.new(identifier, root, path)
    end
    private :module_from_path
    
    def add_module_from_path(path)
      js_module = module_from_path(path)
      top_level_modules << js_module
      collect_dependencies(js_module)
      js_module
    end
    private :add_module_from_path
    
    def to_js(buffer = '')
      buffer << globals
      buffer << "\n(function() {"
      buffer << lib
      buffer << transport
      buffer << requires
      buffer << "})();\n"
    end
    
    def lib
      src = File.read(PATH_TO_MODULR_JS)
      "#{src}\nvar require = modulr.require, module = require.main;\n"
    end
    private :lib
    
    def requires
      top_level_modules.map { |m| m.ensure }.join("\n")
    end
    private :requires
    
    def globals
      ''
    end
    private :globals
    
    def transport
      pairs = modules.map do |m|
        if lazy_eval_module?(m)
          value = m.escaped_src
        else
          value = m.factory
        end
        "\n'#{m.id}': #{value}"        
      end
      "require.define({#{pairs.join(', ')}\n});"
    end
    private :transport
    
    private
      def collect_dependencies(js_module)
        js_module.dependencies.each do |dependency|
          unless modules.include?(dependency)
            modules << dependency
            collect_dependencies(dependency)
          end
        end
      end
      
      def lazy_eval_module?(js_module)
        return false unless @lazy_eval
        return true if @lazy_eval === true
        return true if @lazy_eval.include?(js_module.identifier)
        return true if @lazy_eval.include?(js_module.id)
        false
      end
  end
end