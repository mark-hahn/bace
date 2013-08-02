###
	file: src/client/multibox-client
    settings handler in client

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

bace 	 = (window.bace	?= {})
multibox = (bace.multibox	?= {})
cmdbox   = (bace.cmdbox 	?= {})
dirbox   = (bace.dirbox 	?= {})
edit     = (bace.edit		?= {})

{render,div,img,label,input,button,text,textarea} = teacup

multibox.modeSelect = (mode, src, ml, w, h) ->
	selBrdrW = 2
	render ->
		div {id:mode, class:'modeIcon', \
			 style: "margin-left:#{ml}px; float:left;
				     width:#{w + 2*selBrdrW}px; height:#{h + 2*selBrdrW}px"}, ->

			img {src, style:"position:absolute; left:#{selBrdrW}px; top:#{selBrdrW}px;
							 width:#{w}px; height:#{h}px"}

bace.currentMultiboxMode = null

multibox.init = ($pageHdr) ->
	$multiBox    = $ '#multiBox', $pageHdr
	$modeSelBtns = $ '.modeIcon', $pageHdr

	multibox.setMode = (mode) ->
		$tgt = $ '#'+mode, $pageHdr
		$modeSelBtns.removeClass('modeIconSel'   ).addClass('modeIconNotSel')
		$tgt        .removeClass('modeIconNotSel').addClass('modeIconSel'   )
		bace.currentMultiboxMode = mode
		$multiBox.focus().select()

	$modeSelBtns.click ->
		multibox.setMode $(@).attr 'id'

	$multiBox.keydown (e) ->
#		console.log e.which
		switch e.which
			when 27
				edit.leavingMultibox e.which
			when 13
				switch bace.currentMultiboxMode
					when 'cmdMode'
						cmdbox.enter $multiBox.val()
					when 'dirMode'
#						console.log '$multiBox.keydown dirMode', e.which
						dirbox.enter $multiBox.val()
			when 67
				if e.ctrlKey
					switch bace.currentMultiboxMode
						when 'cmdMode' then cmdbox.ctrl_c()


	multibox.setMode 'dirMode'
	setTimeout (-> $multiBox.focus()), 100
