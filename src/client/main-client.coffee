###
	file: src/client/main-client
    start everything

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###


bace 	 = (window.bace		?= {})
main     = (bace.main		?= {})
header   = (bace.header		?= {})
multibox = (bace.multibox	?= {})
edit     = (bace.edit  		?= {})

{render, div,img,table,tr,td,text} = teacup

$main = null

main.init = ->
	bace.$page.append render ->
		div id:'pageMain', ->
			div id:'editor', ->

	$main = $ '#pageMain', bace.$page

	edit.init $main

bace.barsAtTop = yes

main.resize = (w, h) ->
	bace.$page.css width: w-1, height: h

	if (hdrHgt = header.resize? w, h)
		$main?.css
			width:  w - 18
			height: h - hdrHgt

		if bace.barsAtTop then $main?.css bottom: 0			\
		else				   $main?.css top:    0



