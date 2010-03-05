var inc = require('increment').increment;
var inspect = require('inspect').inspect;
inspect(inc(44));
inspect(require('inspect') === require('inspect'));

var foo = require('foo/foo');
inspect(foo.relative);
inspect(foo.relative === foo.relative2);
inspect(foo.toplevel === require('math').add);
