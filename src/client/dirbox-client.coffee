###
	file: src/client/dirbox-client
    settings handler in client

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
####

bace   = (window.bace	?= {})
dirbox   = (bace.dirbox 	?= {})
edit     = (bace.edit		?= {})
multibox = (bace.multibox	?= {})

{render,div,img,label,input,button,text,textarea} = teacup

dirbox.ctrl_c = ->
	bace.server.emit 'dirCtrl_c'

dirbox.enter = (text) ->
	bace.server.emit 'execDir', {text, cwd: '/bace'}

$ ->
	bace.server.on 'dirResult', (data) ->
		edit.insert data, 1
		multibox.setMode 'dirMode'
