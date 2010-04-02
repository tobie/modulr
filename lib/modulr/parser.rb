require 'rkelly'

module Modulr
  class Parser
    
    def parse(src)
      parser.parse(src)
    end
    
    def get_require_expressions(src)
      nodes = parse(src)
      nodes = nodes.select { |node| is_a_require_expression?(node) }
      nodes.map { |node| normalize(node) }
    end
    
    private                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
      def parser
        @parser ||= RKelly::Parser.new
      end
      
      def is_a_require_expression?(node)
        node.is_a?(RKelly::Nodes::FunctionCallNode) &&
        node.value.is_a?(RKelly::Nodes::ResolveNode) &&
        node.value.value == 'require'
      end
      
      def normalize(node)
        arg = node.arguments.value.first
        valid = arg.is_a?(RKelly::Nodes::StringNode)
        {
          :identifier => valid ? arg.value[1...-1] : nil,
          :src_code => arg.to_ecma,
          :line => arg.line.to_i
        }
      end
  end
end