### global describe, beforeEach, it ###
'use strict'
assert  = require('yeoman-generator').assert
path    = require('path')
helpers = require('yeoman-generator').test

describe 'node-cafe generator', () ->
  before (done) ->
    helpers.run(path.join(__dirname, '../../generators/app'))
    .inDir(path.join(__dirname, '../../temp'))
    .withArguments('hi')
    .withOptions({
      'skip-install': true
    })
    .withPrompt({
      'name': 'myProject'
    })
    .onEnd(() -> done())

  it 'creates the expected config files', (done) ->
    assert.file([
      '.bowerrc'
      '.editorconfig'
      '.dockerignore'
      '.gitignore'
      '.jshintrc'
      '.travis.yml'
      'bower.json'
      'Dockerfile'
      'Gruntfile.coffee'
      'package.json'
    ])
    done()

  it 'creates the expected test files', (done) ->
    assert.file([
      'test/mocha.opts'
      'test/perf/index.coffee'
      'test/unit/index.coffee'
    ])
    done()

  it 'creates the expected source files', (done) ->
    assert.file([
      'src/index.coffee'
      'src/static/css/main.css'
    ])
    done()

  it 'creates expected project files', (done) ->
    assert.file([
      'README.md'
    ])
    done()
