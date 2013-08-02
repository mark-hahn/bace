###
	file: src/client/edit-client
    server.io handler in client

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

bace   = (window.bace	?= {})
edit     = (bace.edit		?= {})
helpers  = (bace.helpers	?= {})
header   = (bace.header	?= {})
settings = (bace.settings	?= {})
multibox = (bace.multibox	?= {})

$editor = editor = null

edit.init = ($main) ->
	$editor = $ '#editor', $main

	ace.Selection = ace.require("./selection").Selection
	ace.Range     = ace.require("./range").Range

	bace.editor = editor = ace.edit "editor"
	session = editor.getSession()

	editor.setTheme "ace/theme/" + (bace.userData.theme ? 'textmate')
#	session.setMode "ace/mode/javascript"
	editor.focus()
	editor.commands.addCommand
	    name: 'openCmdLine'
	    bindKey: win: 'Ctrl-.',  mac: 'Command-.'
	    exec: -> multibox.setMode 'cmdMode'
	    readOnly: true

edit.setSelection = (startRow, startColumn, endRow, endColumn) ->
	range = new ace.Range startRow, startColumn, endRow, endColumn
	editor.getSelection().setSelectionRange range

edit.show = (show = yes) ->
	helpers.showIf $editor, show

edit.resize = (w,h) ->
	if (renderer = bace.editor?.renderer)
		screenSize = [
			80
			renderer.getLastFullyVisibleRow() - renderer.getFirstFullyVisibleRow() + 1
		]
#		console.log screenSize
		bace.server.emit 'termSize', screenSize

edit.insert = (text, pos) ->
	if pos is 1 then editor.navigateFileEnd()
	editor.insert text

edit.leavingMultibox = (key) ->
	editor.focus()
	switch key
		when 38 then editor.navigateUp   1
		when 40 then editor.navigateDown 1
		when 33 then editor.scrollPageUp()
		when 34 then editor.scrollPageDown()
