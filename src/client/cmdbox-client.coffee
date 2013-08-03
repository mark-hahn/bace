###
	file: src/client/cmdbox-client
    settings handler in client

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

bace     = (window.bace	?= {})
cmdbox   = (bace.cmdbox 	?= {})
edit     = (bace.edit		?= {})
multibox = (bace.multibox	?= {})

{render,div,img,label,input,button,text,textarea} = teacup

haveFirstCmd = no

cmdbox.ctrl_c = ->
	haveFirstCmd = yes
	bace.server.emit 'termCtrl_c'

cmdbox.enter = (cmdText) ->
#	console.log 'cmdbox.enter cmdText', cmdText
	haveFirstCmd = yes
	bace.server.emit 'termCmdLine', cmdText

showTermData = (data) ->
	if haveFirstCmd
		edit.insert data, 1
		multibox.setMode 'cmdMode'

$ ->
	bace.server.on 'cmdStdout', showTermData
	bace.server.on 'cmdStderr', showTermData
	bace.server.on 'cmdErr',	  showTermData


