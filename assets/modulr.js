var modulr = (function(global) {
  var _modules = {},
      _moduleObjects = {},
      _references = {},
      _exports = {},
      PREFIX = '__module__'; // Prefix identifiers to avoid issues in IE.
  
  function log(str) {
    if (global.console && console.log) { console.log(str); }
  }
  
  function require(identifier) {
    var id = _references[PREFIX + identifier], fn;
    
    log('Required module "' + identifier + '".');
    
    if (!_exports[id]) {
      fn = _modules[id];
      
      if (!fn) {
        throw 'Can\'t find module "' + identifier + '".';
      }
      
      _exports[id] = {};
      _moduleObjects[id] = { id: id.replace(PREFIX, '') };
      fn(require, _exports[id], _moduleObjects[id]);
    }
    return _exports[id];
  }
  
  function cache(identifier, id, fn) {
    log('Cached module "' + identifier + '".');
    id = PREFIX + id;
    
    if (_modules[id]) {
      throw 'Can\'t overwrite module "' + identifier + '".';
    }
    _modules[id] = fn;
    _references[PREFIX + identifier] = id;
  }
  
  function alias(identifier, id) {
    log('Linked "' + identifier + '" to module "' + id + '".');
    _references[PREFIX + identifier] = PREFIX + id;
  }
  
  return {
    require: require,
    cache: cache,
    alias: alias
  };
})(this);
