var add = require('math').add;
add = require('../example/math').add;

exports.increment = function(val) {
    return add(val, 1);
};