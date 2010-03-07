var modulr = (function(global) {
  var _modules = {},
      _aliases = {},
      _exports = {},
      PREFIX = '__module__'; // Prefix identifiers to avoid issues in IE.
  
  function log(str) {
    if (global.console && console.log) { console.log(str); }
  }
  
  function require(identifier) {
    var moduleFunction, key = PREFIX + identifier;
    log('Required module "' + identifier + '".');
    
    if (_aliases[key]) {
      key = _aliases[key];
      log('Found module "' + identifier + '" as alias of module "' + key.replace(PREFIX, '') + '".');
    }
    
    if (!_exports[key]) {
      moduleFunction = _modules[key];
      if (!moduleFunction) {
        throw 'Can\'t find module "' + identifier + '".';
      }
      _exports[key] = {};
      moduleFunction(require, _exports[key]);
    }
    return _exports[key];
  }
  
  function cache(identifier, fn) {
    var key = PREFIX + identifier;
    log('Cached module "' + identifier + '".');
    
    if (_modules[key]) {
      throw 'Can\'t overwrite module "' + identifier + '".';
    }
    _modules[key] = fn;
  }
  
  function alias(alias, identifier) {
    log('Linked "' + alias + '" to module "' + identifier + '".');
    _aliases[PREFIX + alias] = PREFIX + identifier;
  }
  
  return {
    require: require,
    cache: cache,
    alias: alias
  };
})(this);
