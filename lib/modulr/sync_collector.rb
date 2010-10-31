module Modulr
  class SyncCollector < Collector
    def add_module_from_path(path)
      js_module = super(path)
      modules << js_module unless modules.include?(js_module)
    end
    
    private
      def lib
        output = File.read(PATH_TO_MODULR_SYNC_JS)
        if top_level_modules.size > 1 && !main_module?
          output << "\nvar module = {};\n"
          output << "\nrequire.main = module;\n"
        end
        output
      end
      
      def requires
        top_level_modules.map { |m| "\n  require('#{m.id}');" }.join
      end
  end
end