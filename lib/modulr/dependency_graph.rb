module Modulr
  class DependencyGraph
    def initialize(js_modules)
      if js_modules.is_a?(Array)
        @js_modules = js_modules
      else
        @js_modules = [js_modules]
      end
    end
    
    def to_tree
      return @tree if @tree
      @tree = {}
      @stack = []
      build_tree(@js_modules, @tree)
      @tree
    end
    
    def to_list
      return @list if @list
      @list = {}
      @js_modules.each { |m| build_list(m) }
      @list
    end
    
    def to_yuml
      dep = []
      to_list.map do |k, v|
        if v
          v.each do |i|
            if @list[i]
              dep << "[#{k}]->[#{i}]"
            else
              dep << "[#{k}]-.-Missing>[#{i}{bg:red}]"
            end
          end
        end
        
      end
      "http://yuml.me/diagram/scruffy/class/#{dep.join(',')}."
    end
    
    private
      def build_tree(js_modules, tree)
        js_modules.each do |m|
          id = m.id
          tree[id] = {}
          unless @stack.include?(id)
            @stack << id
            build_tree(m.dependencies, tree[id])
          end
        end
      end
      
      def build_list(js_module)
        begin
          list = @list[js_module.id] ||= []
          js_module.dependencies.each do |m|
            id = m.id
            unless list.include?(id)
              list << id
              build_list(m)
            end
          end
        rescue
          @list[js_module.id] = false
        end
      end
  end
end