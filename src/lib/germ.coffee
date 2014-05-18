### (C) 2014 Narazaka : Licensed under The MIT License - http://narazaka.net/license/MIT?2014 ###
### This software is using Apache License software "request" ###

fs = require 'fs'
path = require 'path'
url = require 'url'
request = require 'request'
jsyaml = require 'js-yaml'
JSZip = require 'jszip'
jconv = require 'jconv'
mkpath = require 'mkpath'

Germ = {}

class Germ.Get
	constructor: () ->
		
	verbose: false
	install: (package_name, callback) ->
		@get_package_database (package_database) =>
			archive_path = @get_archive_path package_name, package_database
			@get_package_information package_name, archive_path, (package_information) =>
				@get_archive archive_path, (data, response) =>
					archive_place_root_directory = @get_archive_place_root_directory package_information
					try
						@place_archive data, package_name, archive_place_root_directory, (install_information) =>
							console.warn 'install finished'
							if callback?
								callback install_information
					catch error
						throw error
	remove: (package_name, callback) ->
		try
			install_information_filename = @install_information_filename(package_name)
			install_information = jsyaml.safeLoad fs.readFileSync install_information_filename, 'utf8'
		catch error
			throw error
		try
			directories = []
			for element in install_information.elements
				stats = fs.statSync element
				if stats.isDirectory()
					directories.push element
				else
					console.warn '-x ', element if @verbose
					fs.unlinkSync element
			for directory in directories.sort().reverse()
				try
					fs.rmdirSync directory
					console.warn '-x ', directory if @verbose
				catch error
					console.warn '-= ', directory if @verbose
			fs.unlinkSync install_information_filename
		catch error
			throw error
		console.warn 'remove finished'
		if callback?
			callback install_information
	search: (package_name_part, callback) ->
		@get_package_database (package_database) ->
			package_matched = []
			for package_name of package_database
				if -1 != package_name.indexOf package_name_part
					package_matched.push package_name
			callback package_matched
	list: (callback) ->
		@get_package_database (package_database) =>
			callback package_database
	information: (package_name, callback) ->
		@get_package_database (package_database) =>
			archive_path = @get_archive_path package_name, package_database
			@get_package_information package_name, archive_path, (package_information) =>
				callback package_information
	get: (package_name, callback) ->
		@get_package_database (package_database) =>
			archive_path = @get_archive_path package_name, package_database
			@get_package_information package_name, archive_path, (package_information) =>
				@get_archive archive_path, (data, response) =>
					archive_filepath = path.basename response.request.uri.path
					fs.writeFileSync archive_filepath, data, 'binary'
					console.warn '-> ', archive_filepath if @verbose
					console.warn 'get finished'
					if callback?
						callback(archive_filepath)
	get_package_list: (callback) ->
		throw 'prease imprement'
	get_package_txt: (package_name, archive_path, callback) ->
		throw 'prease imprement'
	get_archive: (archive_path, callback) ->
		throw 'prease imprement'
	get_archive_path: (package_name, package_database) ->
		archive_path = package_database[package_name]
		if archive_path?
			console.warn 'archive path is ' + archive_path if @verbose
			return archive_path
		else
			throw "package [#{package_name}] not found"
	get_package_database: (callback) ->
		console.warn 'Getting package database' if @verbose
		@get_package_list (data) =>
			package_database = {}
			lines = data.split /\r?\n/
			lines.pop()
			for line in lines
				[package_name, archive_path] = line.split /\t/
				package_database[package_name] = archive_path
			console.warn 'Got package database.' if @verbose
			callback package_database
	get_package_information: (package_name, archive_path, callback) ->
		console.warn 'Getting package information' if @verbose
		@get_package_txt package_name, archive_path, (data) =>
			package_information = jsyaml.safeLoad data
			console.warn 'Got package information' if @verbose
			callback package_information
	get_archive_place_root_directory: (package_information) ->
		cwd = process.cwd()
		place = package_information.place
		if place?
			ghost_root_directory = @detect_ghost_root_directory cwd
			if ghost_root_directory?
				return path.join ghost_root_directory, '.' + place
		return cwd
	encode_package_name: (package_name) ->
		encodeURIComponent(package_name).replace /\*/g, '%2a'
	install_information_filename: (package_name) ->
		'.germ.package.' + @encode_package_name package_name
	place_archive: (data, package_name, root_directory, callback) ->
		zip = new JSZip()
		zip.load data
		install_information = {package_name: package_name, elements: []}
		for filename_key, content of zip.files
			filename = jconv.decode(new Buffer(content.name, 'ascii'), 'SJIS')
			filepath_local = path.join filename
			filepath = path.join root_directory, filepath_local
			dirpath = path.dirname filepath
			install_information.elements.push filepath_local
			console.warn '-> ', filepath if @verbose
			if content.options.dir
				unless fs.existsSync dirpath
					mkpath.sync dirpath
			else
				unless fs.existsSync dirpath
					mkpath.sync dirpath
				try
					fs.writeFileSync filepath, content.asBinary(), 'binary'
				catch error
					throw error
		fs.writeFileSync path.join(root_directory, @install_information_filename package_name), jsyaml.safeDump(install_information), 'utf8'
		if callback?
			callback install_information
	detect_ghost_root_directory: (directory) ->
		if directory.match /\//
			path_separator = '/'
		else
			path_separator = '\\'
		test_directory = directory
		test_directory_old = null
		while test_directory_old != test_directory and not fs.existsSync path.join test_directory, 'install.txt'
			test_directory_old = test_directory
			test_directory = path.dirname test_directory
		if test_directory_old == test_directory
			return null
		else
			return test_directory
###
		if directory.match /\//
			path_separator = '/'
		else
			path_separator = '\\'
		hierarchy = directory.split path_separator
		master = hierarchy.lastIndexOf 'master'
		ghost = hierarchy.lastIndexOf 'ghost'
		shell = hierarchy.lastIndexOf 'shell'
		if ghost == -1 and shell == -1
			install_txt_path = path.join directory, 'install.txt'
			if fs.existsSync install_txt_path
				return '/'
			else
				return null
		else if master != -1
			if ghost != -1 and (master - ghost) == 1
				
			else if shell != -1 and (master - shell) == 1
			else
				
		fs.exists 'install.txt', (exists) ->
			if exists
				directory = '/'
			else
				fs.exists 'master', (exists) ->
					if exists
						cwd = path.basename(process.cwd())
						if cwd == 'ghost'
							directory = '/ghost'
						else if cwd == 'shell'
							directory = '/shell'
					else
						fs.exists 'ghost', (exists) ->
						
###

class Germ.Get.Sync extends Germ.Get
	constructor: () ->
		
	user_agent: 'germ'
	package_list_repository_url: ->
		package_list_repository_url = url.parse 'http://germ.narazaka.net/package_list_repository'
		console.warn 'package_list_repository_url = ' + url.format package_list_repository_url if @verbose
		package_list_repository_url
	package_txt_url: (archive_path) ->
		package_txt_url = url.parse url.resolve archive_path, './package.txt'
		console.warn 'package_txt_url = ' + url.format package_txt_url if @verbose
		package_txt_url
	package_txt_repository_url: (package_name) ->
		package_txt_repository_url = url.parse 'http://germ.narazaka.net/package_txt_repository/'+package_name+'/package.txt'
		console.warn 'package_txt_repository_url = ' + url.format package_txt_repository_url if @verbose
		package_txt_repository_url
	get_package_list: (callback) ->
		@get_file @package_list_repository_url(), (error, response, body) ->
			if error
				throw error
			else if response.statusCode == 404
				throw 'package_list not found'
			else if response.statusCode == 200
				callback body
			else
				throw response.statusCode
	get_package_txt: (package_name, archive_path, callback) ->
		@get_file @package_txt_url(archive_path), (error, response, body) =>
			if error
				throw error
			else if response.statusCode == 404
				console.warn 'package.txt not found in site : using package.txt repository'
				@get_file @package_txt_repository_url(package_name), (error, response, body) =>
					if error
						throw error
					else if response.statusCode == 404
						throw 'package.txt not found anywhere'
					else if response.statusCode == 200
						callback body
					else
						throw response.statusCode
			else if response.statusCode = 200
				callback body
			else
				throw response.statusCode
	get_archive: (archive_path, callback) ->
		console.warn 'Getting archive' if @verbose
		archive_url = url.parse archive_path
		@get_binary_file archive_url, (error, response, body) =>
			if error
				throw error
			else if response.statusCode == 404
				throw 'archive not found in site'
			else if response.statusCode = 200
				console.warn 'Got archive' if @verbose
				callback body, response
			else
				throw response.statusCode
	get_file: (file_url, callback) ->
		request.get
			uri: file_url
			headers:
				'User-Agent': @user_agent
			, callback
	get_binary_file: (file_url, callback) ->
		request.get
			uri: file_url
			encoding: 'binary'
			headers:
				'User-Agent': @user_agent
			, callback

module.exports = Germ
