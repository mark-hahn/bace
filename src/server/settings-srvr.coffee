###
	file: src/server/settings-srvr

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

fs = require 'fs'
user = require './user-srvr'

settings = exports
 
avoidThemes = kr: yes
themeList = []

console.log process.cwd()

allFiles = fs.readdirSync 'ace/src-noconflict'
for file in allFiles
	if (name = /^theme-(.+).js$/.exec file) and not avoidThemes[name[1]]
		themeList.push name[1]

avoidLanguages = {}
languageList = []
allFiles = fs.readdirSync 'ace/src-noconflict'
for file in allFiles
	if (name = /^worker-(.+).js$/.exec file) and not avoidLanguages[name[1]]
		languageList.push name[1]

settings.init = (client) ->

	client.on 'getThemeList', (data) ->
		if client.notSignedIn data.loginData then return
		client.emit 'themeList', themeList

	client.on 'setTheme', (data) ->
		if client.notSignedIn data.loginData then return
		user.saveUserSetting data.loginData.userId, 'theme', data.lbl

	client.on 'getLanguageList', (data) ->
		if client.notSignedIn data.loginData then return
#		console.log 'getLanguageList', languageList
		client.emit 'languageList', languageList

