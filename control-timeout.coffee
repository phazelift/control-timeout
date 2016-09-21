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



class Timeout

	@log 		= types.forceFunction console?.log
	@delay	= 0


	constructor: ( delay ) ->
		@timeout	= {}
		@running	= {}
		@delay	= (Math.abs delay) or Timeout.delay



	exists: ( id ) -> @timeout.hasOwnProperty id


	isRunning: ( id ) -> @running.hasOwnProperty id


	stopOne: ( id ) ->
		clearTimeout @running[ id ]
		delete @running[ id ]
		return @


	stop: ( id ) ->
		if not id then	for id of @running
			@stopOne id
		else
			@stopOne id
		return @


	setTimeout: ( id, action, delay ) ->
		@running[ id ]= setTimeout =>
			delete @running[ id ]
			action()
		, delay
		return @


	run: ( id ) ->
		if types.isString(id) and (@exists id) and (not @isRunning id)
			@setTimeout id, @timeout[ id ].action, @timeout[ id ].delay
		else for id, timeout of @timeout
			if not @isRunning id
				@setTimeout id, timeout.action, timeout.delay
		return @


	removeAll: ( stop ) ->
		@stop() if stop
		@timeout= {}
		return @


	remove: ( id ) ->
		if id= types.forceString id
			@stopOne id
			delete @timeout[ id ]
		else
			Timeout.log 'cannot remove invalid or non-existing timeout!'
		return @


	add: ( id, action, delay ) ->

		settings= types.forceObject id

		if not types.forceString( id, settings.id )
			Timeout.log 'cannot add timeout, invalid or missing arguments!'
			return @

		timeout=
			action	: types.forceFunction action, settings.action
			delay		: types.forceNumber(delay, 0) or types.forceNumber(settings.delay, @delay)

		id= types.forceString( id ) or settings.id

		if @exists id
			Timeout.log 'cannot add timeout, id: '+ id+ ' exists already!'
		else
			@timeout[ id ]= timeout
		return @



module.exports= Timeout