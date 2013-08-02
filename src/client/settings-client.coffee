###
	file: src/client/settings-client
    settings handler in client

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

bace 	 = (window.bace	?= {})
settings = (bace.settings	?= {})
helpers  = (bace.helpers	?= {})
popup    = (bace.popup	?= {})
tabs 	 = (bace.tabs		?= {})
edit     = (bace.edit		?= {})

{render,div,img,label,input,button,text,textarea} = teacup

settings.init = ->
#	console.log 'settings.init'

	bace.server.emit 'getThemeList', {loginData: bace.loginData}
	bace.server.on 'themeList', (themeList) -> bace.themeList = themeList

	bace.server.emit 'getLanguageList', {loginData: bace.loginData}
	bace.server.on 'languageList', (languageList) ->
		bace.languageList = languageList
#		console.log 'languageList', bace.languageList


bace.server.on 'userSetting', (data) ->
	{data, setting, opt} = data

	switch data.setting

		when 'language'
			fields = [ render -> textarea style:"margin:5px; width:240px; height:100", data ]
			$popup = popup.show
				popupId: 		'suffixesPopup'
				right:		20
				top:		35
				width:		300
				height:		150
				title:		"Suffixes for " + opt
				fields:		fields
				showCancel:	yes
				showClose:	yes
				onSubmit:   (values) ->

settingChoices =

	Suffixes: ->
		rows = []
		for language in bace.languageList
			rows.push render -> div class:'settingChoice', language

		$popup = popup.show
			popupId: 		'languagePopUp'
			right:		20
			top:		35
			width:		175
			title:		"Select Language"
			rows:		rows
			showClose:	yes

			onClick: ($tgt) ->
				language = $tgt.text()
				bace.server.emit 'getUserSettings',
					{loginData: bace.loginData, setting: 'suffixes', opt: language}

	User: ->
		fields = [
			popup.inputHtml 'timeoutMins', 'Login Timeout (mins)',
							 bace.userData.timeoutMins, null, null, 'focus'
		]
		$popup = popup.show
			popupId: 		'userSettingPopup'
			right:		20
			top:		35
			width:		250
			height:		300
			title:		"Misc Settings For User"
			fields:		fields
			showCancel:	yes
			showClose:	yes
			onSubmit:   (values) ->
#				console.log 'onSubmit values', values
				for key, val of values
					switch key
						when 'timeoutMins'
							if (val = parseInt(val)) is NaN
								alert 'Login timeout must be numeric'
								return
				bace.server.emit 'setUserSettings',
					{loginData: bace.loginData, values}

	Theme: ->
		if tabs.tabCount() is 0
			tabs.addTab null, 'text'
			edit.insert \
				'\nThis is a sample document to view while trying out different themes.\n\n' +
				'A selected word.', 1
			edit.setSelection 3, 11, 3, 15


		curTheme = bace.editor.getTheme().split('/')[-1..-1][0]
		rows = []
		for theme in bace.themeList
			style = (if curTheme is theme then "background-color:yellow" else '')
			rows.push render -> div {class:'settingChoice', style}, theme

		$popup = popup.show
			popupId: 		'themePopUp'
			right:		20
			top:		35
			width:		250
			title:		"Change Theme (Live)"
			rows:		rows
			showClose:	yes
			onClick: ($tgt) ->
				lbl = $tgt.text()
				$('.settingChoice', $popup).css backgroundColor:'white'
				$tgt.css backgroundColor:'yellow'
				bace.editor.setTheme 'ace/theme/' + lbl
				bace.userData.theme = lbl
				bace.server.emit 'setTheme', {loginData: bace.loginData, lbl}



settings.handleBtn = ($settBtn) ->

	$settBtn.click ->
		rows = []
		for settingChoice of settingChoices
			rows.push render -> div class:'settingChoice', style:"", settingChoice

		popup.show
			popupId: 		'settings'
			right:		20
			top:		35
			width:		100
			title:		"Settings"
			rows:		rows
			showClose:	yes
			onClick: ($tgt) -> settingChoices[$tgt.text()]()

		false
