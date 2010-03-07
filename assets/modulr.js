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
    var fn, modObj,
        id = _references[PREFIX + identifier],
        expts = _exports[id];
    
    log('Required module "' + identifier + '".');
    
    if (!expts) {
      _exports[id] = expts = {};
      _moduleObjects[id] = modObj = { id: id.replace(PREFIX, '') };
      
      if (!require.main) { require.main = modObj; }
      
      fn = _modules[id];
      if (!fn) { throw 'Can\'t find module "' + identifier + '".'; }
      fn(require, expts, modObj);
    }
    return expts;
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
