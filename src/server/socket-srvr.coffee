###
	file: src/server/client-srvr
    server client.io handler for bace

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

fs     = require 'fs'
require 'colors'
hash = md5: (text) -> require('crypto').createHash('md5').update(text).digest 'hex'

settings = require './settings-srvr'
user     = require './user-srvr'
cmdbox   = require './cmdbox-srvr'
dirbox   = require './dirbox-srvr'

sock = exports
client = null

sock.startup = (srvr) ->

	io = require('socket.io').listen srvr, log:no
#	io.set 'log level', 3

	io.sockets.on 'connection',  (clientIn) ->
		client = clientIn
		client.emit 'connected'

		user.init     client
		settings.init client
		cmdbox.init   client
		dirbox.init   client

# for debugging but can be used in production
fs.watch 'src/server/page.css', -> if client then client.emit 'refresh'
fs.watch 'src/client',          -> if client then client.emit 'refresh'

