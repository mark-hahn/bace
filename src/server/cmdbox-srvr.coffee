###
	file: src/server/cmdbox-srvr

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

pty = require 'pty.js'
_   = require 'underscore'

cmdbox = exports

cmdbox.init = (client) ->

#	dump = (s) ->
#		buf = ''
#		for i in [0...s.length]
#			chr =  s.charCodeAt i
#			if chr < 32
#				if buf then console.log buf
#				buf = ''
#				console.log String.fromCharCode(chr + '@'.charCodeAt 0)
#			else
#				buf += String.fromCharCode chr
#		console.log

	term = pty.spawn 'bash', [],
		name: 'xterm-color',
		cols: 80,
		rows: 30,
		cwd: process.env.HOME,
		env: process.env

	client.on 'termSize', (data) ->
		term.resize data...

	client.on 'termCmdLine', (cmd) ->
#		console.log '\n\nterm cmd', cmd
		term.write cmd + '\r'

	client.on 'termCtrl_c', ->
		term.write String.fromCharCode 3

	term.on 'data', (data) ->
#		console.log '\n\nterm data', data
		txt = data.toString().replace(/\x1b\[((([0-9]+;)?[0-9]+)?[@-~])|\r/gi, '')
		client.emit 'cmdStdout', txt

