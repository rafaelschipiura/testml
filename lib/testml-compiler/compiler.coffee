require '../testml-compiler'
require '../testml-compiler/prelude'
require '../testml-compiler/grammar'
require '../testml-compiler/ast'

require('pegex').require 'parser'

parse_testml = (testml_input, testml_file, importer)->
  parser = new Pegex.Parser
    grammar: new TestML.Grammar
    receiver: new TestML.AST
      file: testml_file
      importer: importer
    debug: Boolean TestML.env.TESTML_COMPILER_DEBUG

  parser.parse testml_input

class TestML.Compiler
  ast: null

  compile: (testml_input, testml_file)->
    if TestML.env.TESTML_COMPILER_GRAMMAR_PRINT
      grammar = new TestML.DevGrammar
      grammar.make_tree()
      say JSON.stringify grammar.tree, null, 2
      exit 0

    @ast_to_lingy parse_testml testml_input, testml_file, @importer

  importer: (name, from)->
    if from == '-' or not from.match /\//
      root = '.'
    else
      root = from.replace /^(.*)\/.*/, '$1'

    testml_file = "#{root}/#{name}.tml"
    testml_input = read_file testml_file

    ast = parse_testml testml_input, testml_file, @importer
    ast.code = ast.code[2..]
    ast

  ast_to_lingy: (ast)->
    lingy = JSON.stringify ast, null, 2
    lingy = lingy.replace /\[([^\{\[]+?)\]/g, (m, m1)->
      "[#{m1.replace /\n */g, ''}]"
    lingy = lingy.replace /("=>",)\n *(\[[^\n]*\])/g, '$1$2'
    lingy = lingy.replace /\n *([\}\]])/g, '$1'
    lingy = lingy.replace /\[\n +"/g, '["'
    lingy = lingy.replace /^( *\["%\(\)",)\n *(\[.*\],)$/mg, '$1$2'
    lingy = lingy.replace /(\{)\n +("(?:testml|label)":)/g, '$1 $2'
    lingy + "\n"