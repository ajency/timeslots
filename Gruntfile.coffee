# Generated on 2014-08-22 using generator-angular 0.9.5
"use strict"

# # Globbing
module.exports = (grunt) ->

	# Load grunt tasks automatically
	grunt.loadNpmTasks('grunt-contrib-concat');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks('grunt-contrib-copy');
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-exec'

	# Time how long tasks take. Can help when optimizing build times
	# require("time-grunt") grunt



	# Define the configuration for all the tasks
	grunt.initConfig

		pkg: grunt.file.readJSON('package.json')

		banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
				'<%= grunt.template.today("yyyy-mm-dd") %>\n' +
				'<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
				'* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author %>;' +
				' Licensed MIT \n'+
				'verdor file for jQuery , Backbone, Marionette, underscore, underscore.string */\n'

		concat: 
			options:
				separator: ';'
				stripBanners:  true
				banner: '<%= banner %>'
		
			vendor: 
				src: [	'bower_components/jquery/dist/jquery.js'
						'bower_components/moment/moment.js'
						'bower_components/jquery-ui/ui/core.js'
						'bower_components/jquery-ui/ui/widget.js'
						'bower_components/jquery-ui/ui/mouse.js'
						'bower_components/jquery-ui/ui/draggable.js'
						'bower_components/jqueryui-touch-punch/jquery.ui.touch-punch.min.js'
						'vendor/jquery.mobile-1.4.5/jquery.mobile-1.4.5.js'
						# 'vendor/jQuery-Touch-Events-master/src/jquery.mobile-events.js'
						'bower_components/bootbox/bootbox.js'
						'vendor/bootstrap/js/bootstrap.min.js'
						# 'bower_components/jquery-ui/ui/effect.js'
						# 'vendor/Smooth-Div-Scroll-master/js/jquery-ui-1.10.3.custom.min.js'
						# 'vendor/Smooth-Div-Scroll-master/js/jquery.kinetic.min.js'
						# 'vendor/Smooth-Div-Scroll-master/js/jquery.mousewheel.min.js'
						
						# 'vendor/Smooth-Div-Scroll-master/js/jquery.smoothdivscroll-1.3-min.js'
					]
				dest: 'vendor/vendor.js'


		uglify: 
			vendor:
				options: 
					mangle: true
					compress : true
					sourceMap: true
					banner: '<%= banner %>' 
				files: 
					'vendor/vendor.min.js': ['vendor/vendor.js']

		coffee :
			options : 
				bare : true 
			plugin :
				files : [
					expand: true
					cwd: "lib"
					src: ["*.coffee"]
					dest: "lib"
					ext: ".js"
				]
			tests :
				files : [
					expand: true
					cwd: "tests/specs"
					src: ["*.coffee"]
					dest: "tests/specs"
					ext: ".js"
				]

		watch:
			options:
				livereload: true
				spawn: false
				interrupt: true

			coffee:
				files: [
					"lib/*.coffee"
					"tests/specs/*.coffee"
				]
				tasks: ["coffee:plugin","coffee:tests"]

		copy : 
			main : 
				files : [
						expand: true
						src: ['vendor/*.js']
						dest: 'server/timelinecloud/public'
					,
						expand:true
						src:['vendor/bootstrap/css/bootstrap.min.css']
						dest:'server/timelinecloud/public'
					,
						expand:true
						src:['vendor/bootstrap/fonts/**']
						dest:'server/timelinecloud/public'
					,
						expand:true
						src:['example/**']
						dest:'server/timelinecloud/public'
					,
						expand:true
						src:['lib/*.js']
						dest:'server/timelinecloud/public'
					]

		# exec : 
		# 	watchLib : 
		# 		cmd : 'jitter lib lib -b'
		# 	watchTest : 
		# 		cmd : 'coffee -o tests/js -b -cw tests/js '
		# # 	prod : 
		# # 		cmd : 'grunt vendor && npm run uglifyify-js'
		

		    
		  

	grunt.registerTask "vendor", "Build vendor resources", (target)->
		grunt.task.run [
			"concat:vendor"
			"uglify:vendor"
		]





	grunt.registerTask "watchcoffee", "Start watching coffee files", (target)->
		grunt.task.run [
			"coffee:plugin"
			"coffee:tests"
			"watch:coffee"
			"copy:main"
		]
