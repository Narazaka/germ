#!/usr/bin/env node
// Generated by CoffeeScript 1.7.1

/* (C) 2014 Narazaka : Licensed under The MIT License - http://narazaka.net/license/MIT?2014 */
var Germ, args, argv, germ, package_name;

argv = require('argv');

Germ = require('germ');

argv.info("-- Ukagaka package manager Germ --\ngerm [OPTIONS] (install/remove/update/list/search/info/get) [PACKAGE_NAME]\n");

argv.version('1.0.0');

argv.option([
  {
    name: 'license',
    short: 'l',
    type: 'csv,string',
    description: 'search by license',
    example: '-l mit,cc'
  }
]);


/*
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
 */

args = argv.run();

if (!args.targets.length) {
  argv.help();
  process.exit();
}

germ = new Germ.Get.Sync();

germ.verbose = true;

switch (args.targets[0]) {
  case 'install':
  case 'i':
    package_name = args.targets[1];
    if (!package_name) {
      throw 'no package_name';
    }
    germ.install(package_name);
    break;
  case 'remove':
  case 'r':
    package_name = args.targets[1];
    if (!package_name) {
      throw 'no package_name';
    }
    germ.remove(package_name);
    break;
  case 'list':
  case 'l':
    germ.list(function(package_database) {
      var name, _results;
      _results = [];
      for (name in package_database) {
        _results.push(console.log(name));
      }
      return _results;
    });
    break;
  case 'search':
  case 's':
    package_name = args.targets[1];
    if (!package_name) {
      throw 'no package_name';
    }
    germ.search(package_name, function(list) {
      var element, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = list.length; _i < _len; _i++) {
        element = list[_i];
        _results.push(console.log(element));
      }
      return _results;
    });
    break;
  case 'information':
  case 'info':
    package_name = args.targets[1];
    if (!package_name) {
      throw 'no package_name';
    }
    germ.information(package_name, function(package_information) {
      return console.log("名前: " + package_information.name + "\nバージョン: " + (package_information.version || '') + "\nタイプ: " + (package_information.type || '') + "\n説明: " + (package_information.description || '') + "\nタグ: " + (package_information.tags || '') + "\nサイト: " + (package_information.site || '') + "\nreadme: " + (package_information.readme || '') + "\n配置基準: " + (package_information.place_on || '') + "\n配置場所: " + (package_information.place || '') + "\nライセンス: " + (package_information.licenses || ''));
    });
    break;
  case 'get':
  case 'g':
    package_name = args.targets[1];
    if (!package_name) {
      throw 'no package_name';
    }
    germ.get(package_name);
}

//# sourceMappingURL=germ.map
