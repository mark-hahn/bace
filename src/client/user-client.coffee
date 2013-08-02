###
	file: src/client/user-client
    handle user-spcific chores

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

bace 	 = (window.bace	?= {})
user     = (bace.user 	?= {})
helpers  = (bace.helpers	?= {})
header   = (bace.header	?= {})
main     = (bace.main		?= {})
settings = (bace.settings	?= {})
popup    = (bace.popup	?= {})

user.init = (server) ->

	# try an automatic login
	server.emit 'signIn',
		userId:    helpers.getCookie 'userId'
		token: helpers.getCookie 'token'

	# logged in - start everything
	server.on 'signinSuccess', (userData) ->
		{userId, name, token} = userData

		helpers.setCookie 'userId',    userId
		helpers.setCookie 'token', token

		bace.userData  = userData
		bace.userName  = name
		bace.loginData = {userId, token, name}

		header.init()
		main.init()
		settings.init()
		setTimeout helpers.resizeWin, 100

	# login failed - pop up login dialog
	server.on 'signinFailure', ->
		fields = [
			popup.inputHtml 'name', 'Name', bace.userData?.name ? '', 75, 150, 'focus'
			popup.inputHtml 'password', 'Password', '', 75, 150
		]
		$popup = popup.show
			popupId: 	'loginPopup'
			left:		100
			top:		100
			width:		300
			height:		140
			title:		"Log In"
			fields:		fields
			btnText:	'Submit'
			onSubmit:   (values) ->
				server.emit 'signIn', name: values.name, password: values.password

	# forced logout -- timed out while inactive
	server.on 'signedOut', user.signOut

# clear login credentials and refresh page
user.signOut = ->
	helpers.setCookie 'token', ''
	window.location = '/'

user.logoutBtnPressed = ->
	if confirm 'Press OK to log out and require password on next login.'
		user.signOut()



