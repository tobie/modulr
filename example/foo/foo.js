exports.toplevel = require('math').add;
exports.relative = require('./bar').bar;
exports.relative2 = require('../foo/bar').bar;
exports.relative3 = require('../foo/../foo/./bar').bar;
