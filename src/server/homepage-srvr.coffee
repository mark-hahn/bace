###
	file: src/server/homepage-srvr
    web page for bace

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

tea = require 'teacup'
{render, doctype,html,head,meta,title,style,body,
	div,link,script,h4,img,table,tr,td,text,iframe} = tea

exports.render = ->
	render ->
		doctype 5
		html ->
			head ->
				meta "http-equiv": "Content-Type", content:"text/html; charset=UTF-8"
				title "Bace"
				link href:"/src/server/page.css", rel:"stylesheet", type:"text/css", media:"screen"

			body ->
				div id:"logoStart", style:"position:absolute; top:3px; left:10px; font-Size:14px",
					'(Waiting for log in)'
				div id:'page', ->

				script src:"/lib/jquery-1.10.2.js"
				script src:"/socket.io/socket.io.js"
				script src:"/ace/src-noconflict/ace.js"
				script src:"/lib/teacup.js"
				script src:"/lib/underscore.js"
				script src:"/lib/underscore.string.js"

				script src:"/lib/popup-client.js"
				script src:"/lib/socket-client.js"
				script src:"/lib/user-client.js"
				script src:"/lib/helpers-client.js"
				script src:"/lib/tabs-client.js"
				script src:"/lib/multibox-client.js"
				script src:"/lib/header-client.js"
				script src:"/lib/cmdbox-client.js"
				script src:"/lib/dirbox-client.js"
				script src:"/lib/settings-client.js"
				script src:"/lib/main-client.js"
				script src:"/lib/edit-client.js"
