require 'uri'
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
      build_branch(@js_modules, @tree)
      @tree
    end
    
    def to_list
      return @list if @list
      @list = {}
      @js_modules.each { |m| build_list(m) }
      @list
    end
    
    def to_yuml(options = {})
      options = options.merge({
        :extension => 'png',
        :direction => 'lr',
        :scruffy => true
      })
      dep = @js_modules.map { |m| "[#{m.id}]" }
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
      uri = "http://yuml.me/diagram/"
      uri << "scruffy;" if options[:scruffy]
      uri << "dir:#{options[:direction]}/class/"
      uri << dep.join(',')
      uri << ".#{options[:extension]}"
      URI.encode(uri).gsub('[', '%5B').gsub(']', '%5D')
      
    end
    
    private
      def build_branch(js_modules, branch)
        js_modules.each do |m|
          id = m.id
          branch[id] = {}
          unless @stack.include?(id)
            @stack << id
            build_branch(m.dependencies, branch[id])
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