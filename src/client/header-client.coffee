###
    file: src/client/header-client
###

bace 	 = (window.bace	?= {})
user     = (bace.user  	?= {})
header   = (bace.header	?= {})
tabs 	 = (bace.tabs		?= {})
multibox = (bace.multibox	?= {})
settings = (bace.settings	?= {})

{render,div,img,raw,input} = teacup

header.init = ->
	bace.$page.append render ->
		div id:'pageHdr',  ->
			div id:'logo', 'BACE'
			div id:"logoUser"

			raw multibox.modeSelect 'cmdMode',  "images/Command_Prompt.png",   			  30, 21, 16
			raw multibox.modeSelect 'dirMode',  "images/1374408373_active_directory.png", 10, 19, 16
			raw multibox.modeSelect 'srchMode', "images/mag_glass.png", 			  10, 17, 16

			input id:'multiBox', value: 'header'

			img id:'settingsBtn', src:"images/1374024456_settings.png", \
				style: "width:20px; height:20px;
						position:absolute; right:50px; top:3px; cursor:pointer"

			img id:'logoutBtn', src:"images/logout.png", \
				style: "width:20px; height:20px;
						position:absolute; right:20px; top:3px; cursor:pointer"

	$pageHdr = $ '#pageHdr', bace.$page

	$('#logoStart', $pageHdr).hide()
	$('#logoUser',  $pageHdr).text '(' + bace.userName + ')'

	settings.handleBtn $ '#settingsBtn', $pageHdr
	$('#logoutBtn', $pageHdr).click user.logoutBtnPressed

	header.resize = (w, h) ->
		$('#multiBox', $pageHdr).css width: w - 375
		$('#tabs',     $pageHdr).css width: w - 22

	tabs.init 	  $pageHdr
	multibox.init $pageHdr
