###
	file: src/server/dirbox-srvr

    copyright mark hahn 2013
    MIT license
    https://github.com/mark-hahn/bace/
###

maxLineWidth = 80

_    = require 'underscore'
path = require 'path'
exec = require('child_process').exec

dirbox = exports

dirbox.init = (client) ->

	client.on 'execDir', (data) ->
		text = data.text.replace "'", "\'"
		cmd = 'find ' + data.cwd + " -name '*" + text + "*'"
		opts = cwd: data.cwd

#		console.log 'exec', cmd, opts

		exec cmd, opts, (err, stdout, stderr) ->
			result  = ''
			lastdir = null
			names   = []

#			console.log {err, stdout, stderr}

			namesBreak = ->

				if result.indexOf('express_template.js') > -1 then return

				names.sort()

#				console.log {names}

				abrtCnt = 0

				namesPerLine = names.length
				namesIdx = 0
				while namesIdx < names.length
					if ++abrtCnt is 1000 then break

#					console.log '1', {namesIdx, namesPerLine}

					lineLen = idx = 0
					for name in names[namesIdx...namesPerLine]
						if idx++ is namesPerLine then lineLen = idx = 0
						nameLen = name.length + 2
						if nameLen > maxLineWidth + 2
							namesPerLineChg = no
							namesPerLine = 1
							break
						lineLen += nameLen
						if lineLen > maxLineWidth + 2
							oldNamesPerLine = namesPerLine
							namesPerLine = Math.max 1, Math.min namesPerLine, idx
							namesPerLineChg = (oldNamesPerLine isnt namesPerLine)
							break
					namesIdx += idx

#					console.log '2', {namesIdx, namesPerLine}

					if namesPerLineChg
						continue

#					console.log '3', {namesIdx, namesPerLine}

					numLines = Math.ceil names.length % namesPerLine
					charsPerWord = []
					for i in [0...namesPerLine] then charsPerWord[i] = 0

					idx = 0
					for lineIdx in [0...numLines]
						for wordIdx in [0...namesPerLine]
							if (word = names[idx++])
								charsPerWord[wordIdx] =
									Math.max word.length+2, charsPerWord[wordIdx]

#					console.log '4', {charsPerWord}

					width = 0
					for charCnt in charsPerWord then width += charCnt
					if width > maxLineWidth
						namesPerLine--
						namesIdx = abrtCnt = 0

#					console.log '5', {width, namesPerLine, charsPerWord}

#				console.log {charsPerWord, numLines, namesPerLine}

				idx = 0
				for lineIdx in [0...numLines]
					for wordIdx in [0...namesPerLine]
						if (word = names[idx++])
							while word.length < charsPerWord[wordIdx] then word += ' '
							result += word
					result += '\n'

#				nameLine = ''
#				for name in names
#					if nameLine.length + name.length > maxLineWidth
#						result += nameLine + '\n'
#						nameLine = ''
#					nameLine += name + ' '
#				if nameLine then result += nameLine + '\n'

			dirBreak = ->
				if names.length then namesBreak()
				if dir[0] is '/' then result += '\n### ' + dir + ' ###\n\n'
				lastdir = dir
				names = []

			regex = new RegExp '^(.*)$', 'mg'
			while (parts = regex.exec stdout)
				line = parts[1]
				regex.lastIndex++
				dir  = path.dirname  line
				name = path.basename line
				if dir isnt lastdir then dirBreak()
				names.push name

			dirBreak()

			client.emit 'dirResult', result

