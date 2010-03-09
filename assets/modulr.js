// modulr (c) 2010 codespeaks sàrl
// Freely distributable under the terms of the MIT license.
// For details, see:
//   http://github.com/codespeaks/modulr/blob/master/LICENSE

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
        key = PREFIX + identifier,
        id = _references[key] || key,
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
  
  function cache(id, fn) {
    var key = PREFIX + id;
    
    log('Cached module "' + id + '".');
    if (_modules[key]) {
      throw 'Can\'t overwrite module "' + id + '".';
    }
    _modules[key] = fn;
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
