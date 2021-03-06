module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    bgShell:
      _defaults:
        bg: false
        stdout: true
        stderr:true
        execOpts:
          maxBuffer: false
      test_coveralls:
        cmd: "JSCOV=1 ./node_modules/mocha/bin/_mocha -R mocha-lcov-reporter > ./coverage/lcov.info"
      send_coveralls_coverage:
        cmd: "cat ./coverage/lcov.info | ./node_modules/coveralls/bin/coveralls.js"
      test_coverage:
        cmd: "JSCOV=1 ./node_modules/mocha/bin/_mocha --reporter html-cov > ./coverage/coverage.html"
      open_coverage:
        cmd: "open ./coverage/coverage.html"
      npm_link:
        cmd: "sudo npm link"
      copy_templates:
        cmd: "cp -r templates/templates_app generators/app/templates && cp -r templates/templates_connector generators/connector/templates && cp -r templates/templates_test generators/test/templates && cp -r templates/templates_model generators/model/templates"
      copy_templates_coverage:
        cmd: "cp -r templates/templates_app bin/coverage-generators/app/templates && cp -r templates/templates_connector bin/coverage-generators/connector/templates && cp -r templates/templates_test bin/coverage-generators/test/templates && cp -r templates/templates_model bin/coverage-generators/model/templates"
      build_bin:
        cmd: "mkdir -p bin && cp package.json bin/package.json"
      build_coverage:
        cmd: "mkdir -p ./coverage"

    clean:
      build: ['generators/', 'bin/', 'coverage/']

    coffee:
      compile:
        expand: true
        flatten: false
        cwd: 'src'
        src: ['**/*.coffee']
        dest: '.'
        ext: '.js'

    jscoverage:
      src:
        expand: true,
        cwd:'generators'
        src: ['**/*.js']
        dest: 'bin/coverage-generators'
        ext: '.js'
      helpers:
        expand: true,
        cwd:'helpers'
        src: ['**/*.js']
        dest: 'bin/coverage-helpers'
        ext: '.js'


    mochacli:
      options:
        reporter: 'spec'
        bail: true
      unit: ['test/unit/**/*.coffee']
      perf: ['test/perf/**/*.coffee']

    watch:
      tdd:
        files: ['test/unit/**/*.coffee', 'test/perf/**/*.coffee', 'src/**/*.coffee']
        tasks: 'test'
      unit:
        files: ['test/unit/**/*.coffee', 'src/**/*.coffee']
        tasks: 'test:unit'
      perf:
        files: ['test/perf/**/*.coffee', 'src/**/*.coffee']
        tasks: 'test:perf'

  grunt.loadNpmTasks('grunt-bg-shell')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-jscoverage')
  grunt.loadNpmTasks('grunt-mocha-cli')

  grunt.registerTask('compile', ['clean', 'bgShell:build_bin', 'coffee:compile'])
  grunt.registerTask('build', ['compile', 'bgShell:copy_templates'])
  grunt.registerTask('buildCoverage', ['build', 'jscoverage', 'bgShell:build_coverage', 'bgShell:copy_templates_coverage'])

  grunt.registerTask('test', ['build', 'mochacli'])
  grunt.registerTask('test:unit', ['build', 'mochacli:unit'])
  grunt.registerTask('test:perf', ['build', 'mochacli:perf'])
  grunt.registerTask('test:coveralls', ['buildCoverage', 'bgShell:test_coveralls', 'bgShell:send_coveralls_coverage'])
  grunt.registerTask('test:coverage', ['buildCoverage', 'bgShell:test_coverage', 'bgShell:open_coverage'])

  grunt.registerTask('default', ['build', 'bgShell:npm_link'])
  grunt.registerTask('prepublish', ['build'])
