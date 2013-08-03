###
	file: src/server/user-srvr
    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

fs = require 'fs'
_  = require 'underscore'

require 'colors'
hash  = md5: (text) -> require('crypto').createHash('md5').update(text).digest 'hex'
defaultUserData = require './default-settings'

user = exports
users = null

user.chkUsers = ->

	# if no users file then create it with one user name:"user", pwd:"bacerocks"

	if fs.existsSync 'data/users.json'
		users = JSON.parse fs.readFileSync 'data/users.json', 'utf8'
	else
		if not fs.existsSync 'data' then fs.mkdirSync 'data'
		do -> console.log ('baseic user: Unable to open users.json, creating default user').red
		users = defaultUserData
		fs.writeFileSync 'data/users.json', JSON.stringify users

	# if any user password is plain-text then replace it with hash and seed
	chg		 = no
	delUsers = []

	for name, userData of users
		newUser = userData
		if name.length isnt 32
			_.extend newUser, {name, time: Date.now()}
			users[hash.md5 name] = newUser
			delUsers.push name
			do -> console.log 'Converted user name to userId ' +
								'in data/users.json for user:', newUser.name
			chg = yes

		if newUser.password.length isnt 32
			newUser.seed 	 = '' + Math.floor Math.random() * 1e9
			newUser.password = hash.md5 newUser.seed + newUser.password
			do -> console.log 'Converted plain-text password to hash ' +
								'in data/users.json for user:', newUser.name
			chg = yes

	if chg
		for delUser in delUsers then delete users[delUser]
		fs.writeFileSync 'data/users.json', JSON.stringify users

saveUsers = (userId, data)->
	users = JSON.parse fs.readFileSync 'data/users.json', 'utf8'
	users[userId].time = Date.now()
	users[userId].timeoutMins ?= 60
	if data then _.extend users[userId], data
	fs.writeFileSync 'data/users.json', JSON.stringify users

getUserData = (userId, token, saveUser = yes)->
	users = JSON.parse fs.readFileSync 'data/users.json', 'utf8'
	if not userId or not (userData = users[userId]) or userData.token isnt token or
			Date.now() > userData.time + (userData.timeoutMins ? 60) * 60 * 1000
		return no
	if saveUser then saveUsers userId
	userData.userId = userId
	userData

user.init = (client) ->
	lastLoginData = null

	client.notSignedIn = (loginData, saveUser = yes) ->
		if not getUserData loginData.userId, loginData.token, saveUser
			console.log 'notSignedIn', new Error().stack, loginData
			do -> console.log ('bace: forcing logout for user ' + loginData.name).red
			lastLoginData = null
			client.emit 'signedOut'
			return yes
		no

	startChkLogin = (loginData, userData) ->
		lastLoginData = loginData
		if not chkLogin
			chkLogin = setInterval ->
				if not lastLoginData or client.notSignedIn lastLoginData, no
					clearInterval chkLogin
					chkLogin = null
			, 1000

	client.on 'signIn', (data) ->
		{userId, token, name, password} = data
		password ?= ''

		users = JSON.parse fs.readFileSync 'data/users.json', 'utf8'

		# look up user from name
		if not userId then for userId, userData of users when userData.name is name then break

		#if userId/token not ok then check password
		ok = userData = getUserData userId, token

		if not ok and (userData = users[userId])
			ok = hash.md5(userData.seed + password) is userData.password

		if ok
			token = (userData.token ?= ('' + Math.floor Math.random() * 1e12))
			{name} = userData = users[userId]
			saveUsers userId, {token, name}

			userData.token  = token
			userData.userId = userId
			console.log 'us: signinSuccess', userData
			client.emit 'signinSuccess', userData

			startChkLogin {token, userId, name}, userData
			_.extend client,  {userId, name}
			do -> console.log ("bace: #{name} signed " +
								"in on #{new Date().toString()[0..23]}").blue
		else
			client.emit 'signinFailure'
			do -> console.log 'bace user: SigninFailure for ' + name

	client.on 'getUserSettings', (data) ->
		if client.notSignedIn data.loginData then return
		users = JSON.parse fs.readFileSync 'data/users.json', 'utf8'
		client.emit 'userSetting',
			setting: data.setting
			data: 	 users[client.userId][data.setting]
			opt: 	 data.opt

	client.on 'setUserSettings', (data) ->
		if client.notSignedIn data.loginData then return
		saveUsers client.userId, data.values


user.saveUserSetting = (userId, key, value) ->
	users = JSON.parse fs.readFileSync 'data/users.json', 'utf8'
	users[userId][key] = value
	fs.writeFileSync 'data/users.json', JSON.stringify users