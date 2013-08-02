###
	file: bace
    node server

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

socket = 8935

require('source-map-support').install()
require 'colors'

fs    = require 'fs'
https = require 'https'
_	  = require 'underscore'
_.mixin require('underscore.string').exports()

user  = require './user-srvr'
page  = require './homepage-srvr'
sock  = require './socket-srvr'

# check data/users.json
user.chkUsers()

do -> console.log '------ Starting Bace Server'.green

process.on 'uncaughtException', (args...) ->
	do -> console.log '\nBace Server: ***** uncaughtException ****\n'.red, args

fileTypes = [
	[new RegExp('\\.png$'),				'image/png', 		''		 ]
	[new RegExp('\\.css$'), 			'text/css', 	 	''	 	 ]
	[new RegExp('\\.js$' ), 			'text/javascript',  ''	 	 ]
	[new RegExp('\\.map$|\\.coffee$'),	'text/plain', 		''	 	 ]
	[new RegExp( 'favicon.ico$'), 		'image/x-icon', 	'images/']
]

options =
	cert: fs.readFileSync 'keys/bace-cert.pem'
	key:  fs.readFileSync 'keys/bace-key.pem'

srvr = https.createServer options, (req, res) ->
#	console.log '-- req:', req.url

	for fileType in fileTypes
		[regex, mime, pfx] = fileType
		if not regex.test req.url then continue

		fs.readFile (pfx ? '') + req.url[1..], (err, resp) ->
			if err
#				if not _.endsWith req.url, '.map'
				do -> console.log 'bace: error serving file'.red, req.url, err
				res.writeHead 404
				res.end err.message
			else
				res.writeHead 200, 'Content-Type': mime
				res.end resp
		return

	if req.url is '/'
		res.writeHead 200
		res.end page.render req, res
		return

	do -> console.log 'bace: invalid https request:', req.url
	res.writeHead 404
	res.end ''

srvr.listen socket

sock.startup srvr
