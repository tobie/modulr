require "test/unit"
$:.unshift(File.join('..', 'vendor', 'rkelly', 'lib'))
require "../lib/modulr/parser"

class TestLibModulrParser < Test::Unit::TestCase
  def assert_found_module(name, src, message="")
    @parser ||= Modulr::Parser.new
    template = "Could not find module ? in JavaScript source code ?."
    message = build_message(message, template, name, src)
    assert_block(message) do
      requires = @parser.get_require_expressions(src)
      requires.first && requires.first[:identifier] == name
    end
  end
  
  def test_simple_require_function
    assert_found_module('foo', 'require("foo")')
  end
  
  def test_setting_variable
    assert_found_module('foo', "var bar = require('foo');")
  end
  
  def test_accessing_property
    assert_found_module('foo', "require('foo').bar;")
  end
  
  def test_accessing_nested_property
    assert_found_module('foo', "require('foo').baz.bar;")
  end
  
  def test_calling_method
    assert_found_module('foo', "require('foo').bar();")
  end
  
  def test_calling_nested_method
    assert_found_module('foo', "require('foo').bar.baz();")
  end
  
  def test_instanciating_constructor
    assert_found_module('foo', "new require('foo').Foo();")
    assert_found_module('foo', "new require('foo').Foo;")
    assert_found_module('foo', "new require('foo').Foo(1, 2, 3);")
    assert_found_module('foo', "new (require('foo')).Foo();")
  end
  
  def test_instanciating_nested_constructor
    assert_found_module('foo', "new require('foo').bar.Foo();")
    assert_found_module('foo', "new require('foo').bar.Foo;")
    assert_found_module('foo', "new require('foo').bar.Foo(1, 2, 3);")
    assert_found_module('foo', "new (require('foo').bar).Foo();")
  end
end