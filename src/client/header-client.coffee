###
    file: src/client/header-client
###

bace 	 = (window.bace	?= {})
header   = (bace.header	?= {})
user     = (bace.user  	?= {})
multibox = (bace.multibox	?= {})
settings = (bace.settings	?= {})

{render,div,img,raw,input} = teacup

header.init = ->
	$('#logoStart').hide()

	bace.$page.append render ->
		div id:'statusBar',  ->
			div id:'logo', 'BACE'
			div id:"logoUser"

			img id:'settingsBtn', class:'statusBtn', src:"images/1374024456_settings.png",  \
				style: "right:40px"

			img id:'logoutBtn', class:'statusBtn', src:"images/logout.png", \
				style: "right:10px"

		div id:'boxBar',  ->
			input id:'multiBox'

	$statusBar = $ '#statusBar', bace.$page
	$boxBar    = $ '#boxBar',    bace.$page
	$multiBox  = $ '#multiBox',  $boxBar

	$('#logoUser',  $statusBar).text '(' + bace.userName + ')'

	settings.handleBtn $ '#settingsBtn', $statusBar
	$('#logoutBtn', $statusBar).click user.logoutBtnPressed

	header.resize = (w, h) ->
		statusHgt = $statusBar.outerHeight()
		boxHgt    = $boxBar.outerHeight()
		hdrHgt    = statusHgt + boxHgt

		$statusBar.css top: (if bace.barsAtTop  then         0 else h - statusHgt)
		$boxBar.css    top: (if bace.barsAtTop  then statusHgt else h -    hdrHgt)
		$multiBox.css  width: w - 25

		hdrHgt + 12

	multibox.init $boxBar
