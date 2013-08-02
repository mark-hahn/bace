###
	file: src/client/tabs-client
    settings handler in client

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

bace 	 = (window.bace	?= {})
tabs 	 = (bace.tabs		?= {})
helpers  = (bace.helpers	?= {})
cmdbox   = (bace.cmdbox 	?= {})
edit     = (bace.edit		?= {})

{render,div} = teacup

selectedTabIdx = -1

fileTypeInfo =
	term:
		label:  'Term'
		lblSeq: 0
	dir:
		label:  'Dir'
		lblSeq: 0
	text:
		label:  'Untitled'
		lblSeq: 0

tabs.init = ($pageHdr) ->
	$pageHdr.append render -> div id:'tabsDiv'
	$tabsDiv = $ '#tabsDiv', $pageHdr

	get$tabs = ->
		$tabs = $ '.tab', $tabsDiv
		{$tabs, $tab: $tabs.eq selectedTabIdx}

	tabs.tabCount = -> get$tabs().$tabs.length

	tabs.addTab = (label, fileType = 'text', addRight = yes) ->
		edit.show()

		if not label
			if not (info = fileTypeInfo[fileType])
				info = fileTypeInfo.text
			label = info.label + ' ' + (++info.lblSeq)

		$newTab = $ render ->
			div class:'tab tabNotSel tabClean', label

		if selectedTabIdx is -1
			selectedTabIdx = 0
			$tabsDiv.append $newTab
		else
			{$tab} = get$tabs()
			if addRight then $tab.after $newTab; selectedTabIdx++
			else $tab.before $newTab

		tabs.selectTab selectedTabIdx
		tabs.setData 'fileType', fileType

		helpers.resizeWin()

	tabs.removeTab = ->
		get$tabs().$tab.remove()
		selectedTabIdx--
		tabCount = get$tabs().$tabs.length
		if selectedTabIdx < 0 and tabCount > 0 then selectedTabIdx = 0
		edit.show (tabCount > 0)

	tabs.selectTab = (tabIdx) ->
		selectedTabIdx = tabIdx
		{$tabs, $tab} = get$tabs()
		$tabs.removeClass('tabSel'   ).addClass('tabNotSel')
		$tab .removeClass('tabNotSel').addClass('tabSel'   )

	tabs.getlabel = ->
		get$tabs().$tab.text()

	tabs.setlabel = (label) ->
		get$tabs().$tab.text label

	tabs.setDirty = (dirty = yes) ->
		{$tab} = get$tabs()
		if dirty then $tab.removeClass('tabClean').addClass('tabDirty')
		else     	  $tab.removeClass('tabDirty').addClass('tabClean')

	tabs.getData = (key) ->
		get$tabs().$tab.attr 'data-' + key

	tabs.setData = (key, val) ->
		key = 'data-' + key
		{$tab} = get$tabs()
		if not val? then $tab.removeAttr key
		else $tab.attr key, val

	$tabsDiv.click (e) ->
		bace.editor.focus()
		tabs.selectTab helpers.getSiblingPos e.target

	helpers.resizeWin()
