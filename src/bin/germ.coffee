#!/usr/bin/env coffee
### (C) 2014 Narazaka : Licensed under The MIT License - http://narazaka.net/license/MIT?2014 ###

argv = require 'argv'
Germ = require 'germ'

argv.info """
	-- Ukagaka package manager Germ --
	germ [OPTIONS] (install/remove/update/list/search/info/get) [PACKAGE_NAME]
	
"""
argv.version '1.0.0'
argv.option [
	{
		name: 'license'
		short: 'l'
		type: 'csv,string'
		description: 'search by license'
		example: '-l mit,cc'
	}
]
###
	{
		name: 'sync'
		short: 'S'
		type: 'boolean'
		description: 'Use REMOTE repository'
	}
	{
		name: 'local'
		short: 'L'
		type: 'boolean'
		description: 'Use LOCAL repository'
	}
	{
		name: 'install'
		short: 'i'
		type: 'boolean'
		description: 'install package'
	}
	{
		name: 'remove'
		short: 'r'
		type: 'boolean'
		description: 'remove package'
	}
	{
		name: 'update'
		short: 'u'
		type: 'boolean'
		description: 'update package'
	}
	{
		name: 'search'
		short: 's'
		type: 'boolean'
		description: 'search package'
	}
	{
		name: 'information'
		short: 'q'
		type: 'boolean'
		description: 'show package information'
	}
	{
		name: 'get'
		short: 'g'
		type: 'boolean'
		description: 'get package from REMOTE to LOCAL'
	}
	{
		name: 'database'
		short: 'd'
		type: 'boolean'
		description: 'Update LOCAL database by REMOTE'
	}
	{
		name: 'make'
		short: 'm'
		type: 'boolean'
		description: '-'
	}
###
args = argv.run()

unless args.targets.length
	argv.help()
	process.exit()

germ = new Germ.Get.Sync()
germ.verbose = true

switch args.targets[0]
	when 'install', 'i'
		package_name = args.targets[1]
		throw 'no package_name' unless package_name
		germ.install package_name
	when 'remove', 'r'
		package_name = args.targets[1]
		throw 'no package_name' unless package_name
		germ.remove package_name
	when 'list', 'l'
		germ.list (package_database) ->
			for name of package_database
				console.log name
	when 'search', 's'
		package_name = args.targets[1]
		throw 'no package_name' unless package_name
		germ.search package_name, (list) ->
			for element in list
				console.log element
	when 'information', 'info'
		package_name = args.targets[1]
		throw 'no package_name' unless package_name
		germ.information package_name, (package_information) ->
			console.log """
				名前: #{package_information.name}
				バージョン: #{package_information.version}
				タイプ: #{package_information.type}
				説明: #{package_information.description}
				タグ: #{package_information.tags}
				サイト: #{package_information.site}
				readme: #{package_information.readme}
				配置場所: #{package_information.place}
				ライセンス: #{package_information.license}
			"""
	when 'get', 'g'
		package_name = args.targets[1]
		throw 'no package_name' unless package_name
		germ.get package_name
