###
	file: src/client/popup-client
    popup support

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

bace 	 = (window.bace	?= {})
popup    = (bace.popup	?= {})
helpers  = (bace.helpers	?= {})

{render,div,img,table,tr,td,text,raw,form,label,button,input} = teacup

curPopup = curPopupEscOK = null

closeAllPopups = ->
	$('.popup').remove()
	curPopup = null

isPoppedUp = (popupId) ->
	toggle = (curPopup is popupId)
	closeAllPopups()
	if toggle
		curPopup = null
		return yes
	curPopup = popupId
	no

popup.show = (opts) ->
	{popupId, left, right, top, width, height, title, rows, fields,
		onClick, showCancel, showClose, onClose, btnText, onSubmit} = opts
	if isPoppedUp popupId then return

	curPopupEscOK = not onSubmit or showCancel
	btnText ?= 'Save'

	style = (if left   then "left:#{left}px; "     else '') +
			(if right  then "right:#{right}px; "   else '') +
			(if height then "height:#{height}px; " else '') +
			"top:#{top}px; width:#{width}px"

	bace.$page.append render ->
		div {id:popupId, class:'popup', style}, ->
			div class:"popupHdr", style:"width:#{width-16}", ->
				text title
				if onClose or showClose
					img class:'popupCloseBtn', src:'/images/1374046795_cancel_48.png'
			div class:"popupBody", style:"width:#{width-16}; overflow:auto; position:relative", ->
				div style:"width:100%", ->
					for row in (rows ? []) then raw row
					if fields
						form action:"javascript:void(0)", ->
							for field in fields then raw field
							if onSubmit
								div style:"position:absolute; right:20px; top:#{height-70}px", ->
									if showCancel
										button id:'cancelBtn', type:'button', \
											   style: "clear:both; float:left", 'Cancel'
									button id:'saveBtn', type:'button', \
										   style: "float:left; margin-left:10px", btnText

	$div = $ '#' + popupId, bace.$page

	popup.resize = (w,h) ->
		$div?.css 			maxHeight: h - 80
		$('.popupBody').css height: $div.height() - 30
	helpers.resizeWin()

	$('.focus', $div).focus()

	$('#cancelBtn', $div).click closeAllPopups

	$('#saveBtn', $div).click ->
		formData = {}
		$('input', $div).each -> formData[$(@).attr 'id'] = $(@).val()
		onSubmit? formData
		closeAllPopups()
		false

	$('input', $div).keydown (e) ->
		if e.which is 13 then $('#saveBtn', $div).click()

	$div.click (e) ->
		$tgt = $ e.target
		if $tgt[0] isnt $div[0] and $tgt[0] isnt $('.popupHdr', $div)[0]
			onClick? $tgt
		false

	$('.popupCloseBtn', $div).click ->
		onClose?()
		closeAllPopups()
		false

	$div

popup.inputHtml = (popupId, lbl, val, lblW = 150, inpW = 50, focus = '') ->
	render ->
		div style:"clear:both; margin-left:20px;
				   margin-top:10px; font-size:14px; height:20px", ->
			label for:popupId, style:"clear:both; float:left; width:#{lblW}px; height:20px;
								 text-align:left; margin-top:2px", lbl
			attrs = _.extend {id:popupId, class:focus, value:val, \
								style:"float:left; width:#{inpW}px; height:13px"}, \
							 (if popupId is 'password' then type:"password" else type:"text")
			input attrs

$ ->
	$('body').click ->       if curPopupEscOK then closeAllPopups()
	$('body').keydown (e) -> if curPopupEscOK and e.which is 27 then closeAllPopups()

