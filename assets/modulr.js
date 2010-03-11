// modulr (c) 2010 codespeaks sàrl
// Freely distributable under the terms of the MIT license.
// For details, see:
//   http://github.com/codespeaks/modulr/blob/master/LICENSE

var modulr = (function(global) {
  var _modules = {},
      _moduleObjects = {},
      _exports = {},
      oldDir = '',
      currentDir = '',
      PREFIX = '__module__', // Prefix identifiers to avoid issues in IE.
      RELATIVE_IDENTIFIER_PATTERN = /^\.\.?\//;
  
  function log(str) {
    if (global.console && console.log) { console.log(str); }
  }
  
  function require(identifier) {
    var fn, modObj,
        id = expandIdentifier(identifier),
        key = PREFIX + id,
        expts = _exports[key];
    
    log('Required module "' + identifier + '".');
    
    if (!expts) {
      _exports[key] = expts = {};
      _moduleObjects[key] = modObj = { id: id };
      
      if (!require.main) { require.main = modObj; }
      
      fn = _modules[key];
      oldDir = currentDir;
      currentDir = id.slice(0, id.lastIndexOf('/'));
      
      try {
        if (!fn) { throw 'Can\'t find module "' + identifier + '".'; }
        if (typeof fn === 'string') {
          fn = new Function('require', 'exports', 'module', fn);
        }
        fn(require, expts, modObj);
      } catch(e) { // IE doesn't support `finally` without `catch`.
        throw e;
      } finally {
        currentDir = oldDir;
      }
    }
    return expts;
  }
  
  function expandIdentifier(identifier) {
    if (!RELATIVE_IDENTIFIER_PATTERN.test(identifier)) {
      return identifier;
    }
    var parts = (currentDir + '/' + identifier).split('/'),
        path = [];
    for (var i = 0; i < parts.length; i++) {
      switch (parts[i]) {
        case '':
        case '.':
          continue;
        case '..':
          path.pop();
          break;
        default:
          path.push(parts[i]);
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
