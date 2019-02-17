#
# control-timeout - A timeout class for controlling one or multiple timeouts.
#
# MIT License
#
# Copyright (c) 2016 Dennis Raymondo van der Sluis
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

types= require 'types.js'

moduleName= 'control-timeout'



class Timeout

	@setLog	= ( log ) -> Timeout.log= types.forceFunction log

	@log 		= Timeout.setLog console?.log
	@delay	= 0



	constructor: ( delay ) ->
		@timeouts	= {}
		@running		= {}
		@delay		= (Math.abs delay) or Timeout.delay



	exists: ( id ) -> @timeouts.hasOwnProperty id


	isRunning: ( id ) -> @running.hasOwnProperty id


	_stopOne: ( id ) ->
		if @isRunning id
			clearTimeout @running[ id ]
			delete @running[ id ]
		return @


	stop: ( ids... ) ->
		if not ids.length then for id of @running
			@_stopOne id
		else for id in ids
			@_stopOne id
		return @


	setDelay: ( id, delay ) ->
		if @exists id
			@timeouts[ id ].delay= types.forceNumber delay, @timeouts[ id ].delay


	getTimeout: ( id ) -> @running[ id ]


	_setTimeout: ( id, action, delay ) ->
		return @running[ id ]= setTimeout =>
			delete @running[ id ]
			action()
		, delay


	run: ( id, args... ) ->
		timeouts= []
		if not id then for id, timeout of @timeouts
			if not @isRunning id
				timeouts.push @_setTimeout id, timeout.action.bind(null, args...), timeout.delay
		else if @exists id
			timeouts.push @_setTimeout id, @timeouts[id].action.bind(null, args...), @timeouts[id].delay
		else
			Timeout.log moduleName+ ': timeout with id: "'+ id+ '" was not found'

		switch timeouts.length
			when 0 then return null
			when 1 then return timeouts[0]
			else return timeouts


	removeAll: () ->
		@stop()
		@timeouts= {}
		return @


	remove: ( ids... ) ->
		if ids.length then for id in ids
			@_stopOne id
			delete @timeouts[ id ]
		else
			Timeout.log moduleName+ ': cannot remove, invalid or non-existing timeout!'
		return @


	_add: ( id, action, delay ) ->
		if types.notString(id) or not id.length
			Timeout.log moduleName+ ': cannot add timeout, invalid or missing id!'
		else if @exists id
			Timeout.log moduleName+ ': cannot add timeout, id: '+ id+ ' exists already!'
		else
			@timeouts[ id ]=
				action	: types.forceFunction action
				delay		: Math.abs types.forceNumber( delay, @delay )
		return @


	add: ( id, action, delay ) ->
		if types.isObject id
			return @_add id.id, id.action, id.delay
		else
			return @_add id, action, delay



module.exports= Timeout