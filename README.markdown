modulr
======

Description
-----------

`modulr` is a [CommonJS module implementation](http://commonjs.org/specs/modules/1.0.html)
in Ruby for client-side JavaScript.

* [Github repository](http://github.com/codespeaks/modulr)
* [Specification](http://wiki.commonjs.org/wiki/Modules/1.0)

Install
-------

    $ [sudo] gem install modulr

Usage
-----

`modulr` accepts a singular file as input (the _program_) on which is does static
analysis to recursively resolve its dependencies.

The program, its dependencies and a small, namespaced JavaScript library are concatenated into a single `js` file. This
[improves load times by minimizing HTTP requests](http://developer.yahoo.com/performance/rules.html#num_http).

The bundled JavaScript library provides each module with the necessary `require`
function and `exports` and `module` free variables.

`modulr` is available as a Ruby program or as a command-line utility (`modulrize`).

Specs
-----

To run the specs, first clone the Git repository then grab the CommonJS
specs, included as a Git submodule, by running:

    $ git clone git://github.com/codespeaks/modulr.git
    $ cd modulr
    $ git submodule init
    $ git submodule update

[Mozilla's SpiderMonkey](http://www.mozilla.org/js/spidermonkey/) is required
and the `js` command line executable must be available on the load path (try `which js`).

You can run all the specs by issuing:

    $ rake spec

Alternatively, a list of comma-separated specs can be specified through the `SPECS`
environment variable (see `vendor/commonjs/tests/modules/1.0`) for a comprehensive
list of available specs).

    $ rake spec SPECS=absolute,transitive
