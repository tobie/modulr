modulr
======

Description
-----------

modulr is a CommonJS module implementation in Ruby for client-side JavaScript.

* Repository: http://github.com/codespeaks/modulr
* Specification: http://wiki.commonjs.org/wiki/Modules/1.0

Install
-------

    $ [sudo] gem install modulr

Specs
-----

To run the specs, you must first clone the Git repository then grab CommonJS
specs, included as Git submodule, by running:

    $ git clone git://github.com/codespeaks/modulr.git
    $ cd modulr
    $ git submodule init
    $ git submodule update

[Mozilla's SpiderMonkey](http://www.mozilla.org/js/spidermonkey/) is required
and the `js` command line executable must be available on the load path (try `which js`).

You can then run all the specs by issuing:

    $ rake spec

Alternatively, a list of comma-separated specs can be specified through the SPECS
environment variable (see vendor/commonjs/tests/modules/1.0 for a comprehensive
list of available specs).

    $ SPECS=absolute,transitive rake spec
