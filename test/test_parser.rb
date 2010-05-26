require "test/unit"
$:.unshift(File.join('..', 'vendor', 'rkelly', 'lib'))
require "../lib/modulr/parser"

class TestLibModulrParser < Test::Unit::TestCase
  def get_module_identifier(src)
    @parser ||= Modulr::Parser.new
    @parser.get_require_expressions(src).first[:identifier]
  end
  
  def test_simple_require_function
    assert_equal 'foo', get_module_identifier('require("foo")')
  end
  
  def test_setting_variable
    assert_equal 'foo', get_module_identifier("var bar = require('foo');")
  end
  
  def test_accessing_property
    assert_equal 'foo', get_module_identifier("require('foo').bar;")
  end
  
  def test_calling_method
    assert_equal 'foo', get_module_identifier("require('foo').bar();")
  end
  
  def test_instanciating_constructor
    assert_equal 'foo', get_module_identifier("new require('foo').Foo();")
    assert_equal 'foo', get_module_identifier("new require('foo').foo.Foo();")
    assert_equal 'foo', get_module_identifier("new (require('foo')).Foo();")
    assert_equal 'foo', get_module_identifier("new require('foo').Foo;")
    assert_equal 'foo', get_module_identifier("new require('foo').Foo(1, 2, 3);")
  end
end