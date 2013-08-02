###
	file: src/client/socket-client
    server.io handler in client

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

bace = (window.bace	?= {})
user   = (bace.user	?= {})

bace.server = server = io.connect '/'

$ ->
	user.init server

	server.on 'refresh', ->
		window.location = '/'

