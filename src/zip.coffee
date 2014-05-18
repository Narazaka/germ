fs = require 'fs'
path = require 'path'
jconv = require 'jconv'
JSZip = require 'jszip'


unnar = (nar_filename) ->
	try
		zip_data = fs.readFileSync nar_filename, 'binary'
	catch error
		throw error
	zip = new JSZip()
	zip.load zip_data
	for filename_key, content of zip.files
		filename = jconv.decode(new Buffer(content.name, 'ascii'), 'SJIS')
		dir = path.dirname filename
		if not content.options.dir
			unless fs.existsSync dir
				fs.mkdirSync dir
			try
				fs.writeFileSync filename, content.asBinary(), 'binary'
			catch error
				throw error

unnar ''
