###
	file: src/server/client-srvr
    server client.io handler for bace

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

fs    = require 'fs'
_     = require 'underscore'
_.mixin require('underscore.string').exports()

require 'colors'

settings = require './settings-srvr'
user     = require './user-srvr'
cmdbox   = require './cmdbox-srvr'
dirbox   = require './dirbox-srvr'

sock = exports

clientList = {}

sock.startup = (srvr) ->

	io = require('socket.io').listen srvr, log:no
#	io.set 'log level', 3

	io.sockets.on 'connection',  (client) ->
		client.emit 'connected'

		clientList[client.id] = client

		user.init     client
		settings.init client
		cmdbox.init   client
		dirbox.init   client

		client.on 'disconnect', -> delete clientList[client.id]

refreshAllClients = ->
	console.log 'ss: refreshAllClients', _.size clientList
	for id, client of clientList
		client.emit 'refresh'

if fs.existsSync 'src'
	# for debugging but can be used in production
	fs.watch 'lib/page.css', refreshAllClients
	fs.watch 'src/client',   refreshAllClients

