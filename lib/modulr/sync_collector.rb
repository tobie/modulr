module Modulr
  class SyncCollector < Collector
    def add_module_from_path(path)
      js_module = super(path)
      modules << js_module unless modules.include?(js_module)
    end
    
    def lib
      File.read(PATH_TO_MODULR_SYNC_JS)
    end
    private :lib
    
    def requires
      top_level_modules.map { |m| "\n  require('#{m.id}');" }.join
    end
    private :requires
    
  end
end