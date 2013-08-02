###
	file: src/client/main-client
    start everything

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###


bace 	 = (window.bace	?= {})
main     = (bace.main		?= {})
multibox = (bace.multibox	?= {})
edit     = (bace.edit  	?= {})

{render, div,img,table,tr,td,text} = teacup

$main = null

main.init = ->
	bace.$page.append render ->
		div id:'pageMain', ->
			div id:'editor', ->

	$main = $ '#pageMain', bace.$page

	edit.init $main

main.resize = (w,h) ->
	hdrHgt = $('#pageHdr').outerHeight()
	bace.$page.css width: w-1, height: h
	$main?.css
		top: hdrHgt
		width: w
		height: h - hdrHgt - 4

