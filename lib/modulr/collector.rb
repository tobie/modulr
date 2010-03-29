module Modulr
  class Collector
    attr_reader :modules, :main
    
    def initialize(options = {})
      @root = options[:root]
      @lazy_eval = options[:lazy_eval]
      @modules = []
    end
    
    def parse_file(path)
      @src = File.read(path)
      @root ||= File.dirname(path)
      @main = JSModule.new(File.basename(path, '.js'), @root, path)
      modules << main
      collect_dependencies(main)
    end
    
    def to_js(buffer = '')
      buffer << File.read(PATH_TO_MODULR_JS)
      buffer << "\n(function(require, module) {"
      buffer << transport
      buffer << main.ensure
      buffer << "})(modulr.require, {});\n"
    end
    
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