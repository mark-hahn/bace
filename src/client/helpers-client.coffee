###
    file: src/client/helpers-client
###

bace 	= (window.bace	?= {})
helpers = (bace.helpers	?= {})
main    = (bace.main	?= {})
header  = (bace.header	?= {})
popup   = (bace.popup	?= {})
edit    = (bace.edit	?= {})

helpers.setCookie = (name, value, days = 365) ->
#	xdbg 'setCookie (name, value, days)', name, value, days
	date = Date.now() + days*24*60*60*1000
	expires = "; expires=" + new Date(date).toUTCString()
	document.cookie = "#{name}=#{value}#{expires}; path=/"

helpers.getCookie = (name) ->
	for cookie in document.cookie.split ';'
		parts = cookie.match ///^ \s* ([^=\s]+) \s* = (.*) $///
		if parts?[1] == name
			return switch parts[2]
				when 'undefined' then undefined
				when 'null'  	 then null
				when 'false' 	 then false
				when 'true'  	 then true
				else parts[2]
	null

helpers.clearCookie = clearCookie = (name) -> helpers.setCookie name, "", -1

helpers.clearAllCookies = ->
	for cookie in document.cookie.split ";"
		helpers.clearCookie cookie.split('=')[0]

helpers.getSiblingPos = (oElement) ->
	$(oElement).parent().children(oElement.nodeName).index(oElement);

$window = $ window

helpers.resizeWin = ->
	w = $window.width()
	h = $window.height()

	main.resize?   w, h
	header.resize? w, h
	popup.resize?  w, h
	edit.resize?   w, h

helpers.showIf = ($ele, show) -> if show then $ele.show() else $ele.hide()

$ ->
	bace.$page = $ '#page'
	$window.resize helpers.resizeWin
