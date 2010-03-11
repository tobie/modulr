// modulr (c) 2010 codespeaks sàrl
// Freely distributable under the terms of the MIT license.
// For details, see:
//   http://github.com/codespeaks/modulr/blob/master/LICENSE

var modulr = (function(global) {
  var _modules = {},
      _moduleObjects = {},
      _exports = {},
      _oldDir = '',
      _currentDir = '',
      PREFIX = '__module__', // Prefix identifiers to avoid issues in IE.
      RELATIVE_IDENTIFIER_PATTERN = /^\.\.?\//;
  
  function log(str) {
    if (global.console && console.log) { console.log(str); }
  }
  
  function require(identifier) {
    var fn, modObj,
        id = resolveIdentifier(identifier),
        key = PREFIX + id,
        expts = _exports[key];
    
    log('Required module "' + identifier + '".');
    
    if (!expts) {
      _exports[key] = expts = {};
      _moduleObjects[key] = modObj = { id: id };
      
      if (!require.main) { require.main = modObj; }
      
      fn = _modules[key];
      _oldDir = _currentDir;
      _currentDir = id.slice(0, id.lastIndexOf('/'));
      
      try {
        if (!fn) { throw 'Can\'t find module "' + identifier + '".'; }
        if (typeof fn === 'string') {
          fn = new Function('require', 'exports', 'module', fn);
        }
        fn(require, expts, modObj);
        _currentDir = _oldDir;
      } catch(e) {
        _currentDir = _oldDir;
        // We'd use a finally statement here if it wasn't for IE.
        throw e;
      }
    }
    return expts;
  }
  
  function resolveIdentifier(identifier) {
    var parts, part, path;
    
    if (!RELATIVE_IDENTIFIER_PATTERN.test(identifier)) {
      return identifier;
    }
    
    parts = (_currentDir + '/' + identifier).split('/');
    path = [];
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      switch (part) {
        case '':
        case '.':
          continue;
        case '..':
          path.pop();
          break;
        default:
          path.push(part);
      }
    }
    return path.join('/');
  }
  
  function cache(id, fn) {
    var key = PREFIX + id;
    
    log('Cached module "' + id + '".');
    if (_modules[key]) {
      throw 'Can\'t overwrite module "' + id + '".';
    }
    _modules[key] = fn;
  }
  
  return {
    require: require,
    cache: cache
  };
})(this);
