Germ = require './germ.js'

gs = new Germ.Get.Sync()
gs.verbose = true

gs.search 'te', (matched) -> console.log matched
console.log gs.detect_ghost_root_directory process.cwd()

package_name = 'test'
gs.install package_name, (install_information) ->
	gs.remove package_name

###
gs.get_package_database (package_database) ->
	console.log package_database
	archive_path = gs.get_archive_path package_name, package_database
	console.log archive_path
	gs.get_package_information package_name, archive_path, (package_information) ->
		console.log package_information
		console.log gs.detect_ghost_root_directory process.cwd()
		archive_place_root_directory = gs.get_archive_place_root_directory package_information
		console.log archive_place_root_directory
		gs.get_archive archive_path, (data) ->
			try
				console.log 'zip'
				gs.place_archive data, package_name, archive_place_root_directory
			catch error
				throw error
			console.warn 'install finished'
###
