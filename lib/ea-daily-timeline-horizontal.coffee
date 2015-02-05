( ($)->

	root = @
	usedColors = []

	# hasChild = ($parent,className)->
	# 	$parent.find(".#{className}").length > 0

	

	

	

	

	
	


	addTimeSlots = ($parent, options)->

		timeArray = options.timeArray

		width = $parent.find('.timeline-interval-region').width()

		pixelPerSecond = getPixelPerSecond timeArray,width

		for time,i in timeArray
			if i is 0
				if options.showStartEndTimes
					$parent.find('.timeline-slot-region').append "<div  class='slot-interval' >
												<div class='slot-interval-time first'>
													#{moment.unix(time).format('H:mm')}
												</div>
												</div>"
				continue

			slotTime = time - timeArray[i-1]
			totalTime = timeArray[timeArray.length-1] - timeArray[0]
			percentage = Math.floor(slotTime * pixelPerSecond)
			color = getRandomColor()
			$parent.find('.timeline-slot-region').append "<div data-slot='#{i-1}' class='slot' style='background-color: #{color}; width: #{percentage}px'></div>"
			addDescription $parent,timeArray[i-1],time,color,i-1
			
			if options.showStartEndTimes
				if i < timeArray.length-1
					$parent.find('.timeline-slot-region').append "<div  class='slot-interval' ><div class='slot-interval-time'>#{moment.unix(time).format('H:mm')}</div></div>"
				else
					$parent.find('.timeline-slot-region').append "<div  class='slot-interval' ><div class='slot-interval-time last'>#{moment.unix(time).format('H:mm')}</div></div>"

			

		$( ".overflow-timeline" ).draggable
				axis:'x'
				scroll:false
				drag:(e,ui)->
					# console.log 's'
					e.stopPropagation()
					innerWidth = $( ".overflow-timeline" ).width()
					outerWidth = $( ".overflow-timeline" ).parent().width()
					positionLeft =  ui.position.left
					if positionLeft < outerWidth - innerWidth 
						# console.log positionLeft
						ui.position.left = outerWidth - innerWidth
						# $( ".overflow-timeline" ).css 'left', (outerWidth - innerWidth) + 'px'
					if positionLeft > 0
						# console.log positionLeft
						ui.position.left = 0

						# $( ".overflow-timeline" ).css 'left', '0px'

		$( ".overflow-timeline" ).css 'display','inline-table'
					


	addDescription =($parent, slotStart, slotEnd, color,slotId)->
		duration = moment.unix(slotEnd).diff(slotStart*1000)
		diff = ''#"#{moment.duration(duration).hours()}:#{moment.duration(duration).minutes()}"
		if moment.duration(duration).hours()
			diff += "#{moment.duration(duration).hours()} hr"
		if moment.duration(duration).hours() and moment.duration(duration).minutes()
			diff += ', '
		if moment.duration(duration).minutes()
			diff += "#{moment.duration(duration).minutes()} min"
		$parent.find('.time-description').append "<div data-slot='#{slotId}' class='slot'><div class='slot-time' style='background-color:#{color}'>#{diff}</div></div>"

	index = [1,1,1,1,1,1]

	getRandomColor = ->

		

		letters = '6789ABCDEF'.split('');
		color = '#';
		for i in [0..5]
			if i%2
				index[i] = (index[i]+Math.floor(Math.random()*10))%10
			else 
				val = (index[i]-Math.floor(Math.random()*10))%10
				index[i] = if val < 0 then 10 + val else val
			color += letters[index[i]];
			# color += 'A'

		if color not in usedColors
			usedColors.push color

		else
			color = getRandomColor()

		
		color;

# public funcions

	validateSameDayTime = (timeArray)->
		for time in timeArray
			if date and date isnt moment.unix(time).format('L')
				return false
			else
				date = moment.unix(time).format('L')
		true

	validateTimeArray = (timeArray)->

		# checks that argument passed is an array
		if not Array.isArray(timeArray)
			return false

		if timeArray.length < 2
			return false

		currentTime = getCurrentTimestamp()
		for time in timeArray
			if time < 1262304000 or time > currentTime
				return false


		if not validateSameDayTime timeArray
			return false 

		return true

	getCurrentTimestamp = ->
		timestamp = (new Date()).getTime() / 1000
		Math.floor(timestamp)

	createChildRegion = ($parent)->
		$parent.html "	<div class='timeline'>
							<div class='overflow-timeline'>
								<div class='timeline-interval-region' style='height: 25px; position: relative;'></div>
								<div class='timeline-slot-region'></div>
							</div>
						</div>
						<div class='time-description'></div>"

	getStartTime  = (timeArray)->
		timeArray[0] 

	getEndTime = (timeArray)->
		timeArray[timeArray.length-1]

	getHourArray = ( timeArray )->
		startTime = getStartTime timeArray
		endTime = getEndTime timeArray

		intervalArray = []

		startHour = moment.unix(startTime).hour()
		endHour = moment.unix(endTime).hour()

		totalSeconds = endTime - startTime

		# interval hour shud be between star and end time 
		tempHour = startHour + 1

		tempMoment = moment.unix(startTime)

		while tempHour <= endHour
			tempMoment.hour(tempHour)
			tempTime = tempMoment.unix()
			intervalSeconds = tempTime - startTime
			intervalPercent = intervalSeconds * 100 / totalSeconds
			intervalLabel = tempMoment.format('ha');
			if intervalPercent > 5 and intervalPercent < 95
				intervalArray.push 
					label : intervalLabel
					percentage : intervalPercent
			tempHour += 1

		intervalArray

	insertTimelineInterval = ($parent, intervalArray)->
		width = $parent.find('.timeline-interval-region').width()
		# allowedInterval = (width / 50) - 1
		# actualIntervalLength = intervalArray.length
		# while actualIntervalLength > allowedInterval
		# 	actualIntervalLength = Math.ceil actualIntervalLength/2

		allowedIndices = getAllowedIntervalLabel width,intervalArray.length

		for interval,i in intervalArray
			
			# if (i+1)%(Math.ceil(intervalArray.length/actualIntervalLength)) 
				# console.log (i+1)%(Math.ceil(intervalArray.length/actualIntervalLength))
				# continue
			if i+1 in allowedIndices
				left = (interval.percentage * width / 100)-20
				$parent.find('.timeline-interval-region').append "<div class='time-interval' style='left : #{interval.percentage}%'><div>#{interval.label}</div></div>"

	getAllowedIntervalLabel = (width,actualNumberOfLabels)->
		allowedNumberOfLabels = (width / 50) 
		tempNumberOfLabels = actualNumberOfLabels
		# while tempNumberOfLabels > allowedNumberOfLabels
		# 	tempNumberOfLabels = Math.ceil tempNumberOfLabels/2
		divisor = Math.ceil actualNumberOfLabels/allowedNumberOfLabels

		allowedIndex = []
		for i in [1..actualNumberOfLabels]
			if i%divisor is 0 and i isnt 0
				allowedIndex.push i
		allowedIndex

	getPixelPerSecond = (timeArray,width)->
		shortestSlot = 100000
		for time,i in timeArray
			if i is 0 then continue
			if shortestSlot > time - timeArray[i-1]
				shortestSlot = time - timeArray[i-1]
		pps = 40/shortestSlot

		ppsTotal = width/(timeArray[timeArray.length-1]-timeArray[0])

		pixelPerSecond = if pps > ppsTotal then pps else ppsTotal

		pixelPerSecond

	addSwipeEventHandlers = ($parent, options)->

		# startX = startY = distX = distY = 0


		$timeslotDescription = $parent.find('.time-description .slot')

		$timeslotDescription.on 'swiperight',(e)->

			if $(e.target).closest('.time-description').hasClass 'combine-parent' then return

			# newMoment = moment.unix(options.timeArray[0])
			if not $(e.target).hasClass 'slot'
				return
			slotNo = parseInt $(e.target).attr 'data-slot'
			slotStart = options.timeArray[slotNo]
			slotEnd = options.timeArray[slotNo+1]
			duration = moment.unix(slotEnd).diff(moment.unix(slotStart),'minutes')
			console.log duration
			console.log 'split'
			bootbox.dialog
				title : 'Create new slot'
				message : '
							<div>
							<span> Start time : '+moment.unix(slotStart).format('h:mm a')+' </span>
							</div><div>
							<span> End time : '+moment.unix(slotEnd).format('h:mm a')+' </span>
							</div>
							<div><span>Duration : '+duration+' minutes</span></div>
							<div class="split-time">
								Enter new slot time   
							<span>
								<input type="number" maxlength="2" min="0" max="24" class="new-slot"/>
							</span>  minutes
							<div>
								add new slot at the </br>
								<input type="radio" name="newSlotPosition" value="start" checked>Start
								<input type="radio" name="newSlotPosition" value="end">End

							</div>
						</div>'
				buttons :
					cancel :
						label : 'Cancel'
						className : 'btn-failure'
					split:  
						label : 'Split'
						className : 'btn-primary'
						callback : ->
							timeMinutes = parseInt $('.split-time .new-slot').val()
							slotMinutes = if timeMinutes >0 and timeMinutes < duration then timeMinutes else ''
							if slotMinutes is '' then return
							newMoment = moment.unix(slotStart)
							# newMoment.hour hour
							console.log $('input[name="newSlotPosition"]').val()
							if $('input[name="newSlotPosition"]:checked').val() is 'end'
								newMoment.add duration-slotMinutes, 'm'
							else
								newMoment.add slotMinutes,'m'

							newMomentUnix = newMoment.unix()
							if newMomentUnix > slotStart and newMomentUnix < slotEnd
								options.timeArray.push newMomentUnix
								options.timeArray.sort()
								if options.onSplitSlot? and typeof options.onSplitSlot is 'function'
									options.onSplitSlot.call @, options.timeArray
								$parent.trigger 'refresh'

					



		$timeslotDescription.on 'swipeleft',(e)->
			if $(e.target).closest('.time-description').hasClass 'combine-parent' then return
			if not $(e.target).hasClass 'slot' then return

			slotNo = parseInt $(e.target).attr 'data-slot'

			isFirst = if slotNo is 0 then true else false
			isLast = if slotNo is options.timeArray.length-2 then true else false

			if isFirst and isLast then return


			$(e.target).closest('.time-description').addClass 'combine-parent'

			$(e.target).addClass 'combine-current'
			$(e.target).append '<span class="cancel-combine"><i class="glyphicon glyphicon-remove"></i></span>'

			if not isFirst
				$('.time-description.combine-parent .slot[data-slot="'+(slotNo-1)+'"]').addClass 'combine-neighbour'

			if not isLast 
				$('.time-description.combine-parent .slot[data-slot="'+(slotNo+1)+'"]').addClass 'combine-neighbour'

			$('.time-description.combine-parent .slot.combine-neighbour').on 'tap',combineSlots.bind @, $parent, options,slotNo
			$('.time-description.combine-parent .slot.combine-current .cancel-combine').on 'tap',stopCombineSlot.bind @,$parent
			


	combineSlots = ($parent, options, slotNo, e)->
		console.log 'combine'
		neighbourSlot = parseInt $(e.target).attr 'data-slot'
		if neighbourSlot < slotNo
			options.timeArray.splice slotNo,1
		else if neighbourSlot > slotNo
			options.timeArray.splice slotNo+1, 1
		
		stopCombineSlot $parent

		if options.onCombineSlot? and typeof options.onCombineSlot is 'function'
				options.onCombineSlot.call @, options.timeArray

		$parent.trigger 'refresh'

	stopCombineSlot = ($parent)->
		$('.time-description.combine-parent .slot.combine-current .cancel-combine').off().remove()
		$('.time-description.combine-parent .slot.combine-neighbour').off('tap').removeClass 'combine-neighbour'
		$('.time-description.combine-parent .slot.combine-current').removeClass 'combine-current'
		$('.time-description.combine-parent ').removeClass 'combine-parent'

		

		



	render = (options)->

			$parent = @

			if not validateTimeArray options.timeArray
				throw 'The timeArray passed is not valid'

			# sort time array in asscending order
			options.timeArray.sort()

			# create main regions
			createChildRegion $parent

			
			$parent.find('.timeline').css 
					'width':'100%'
					'overflow-x' : 'hidden'

			intervalArray = getHourArray options.timeArray

			addTimeSlots $parent, options

			# add hourly ime interval
			insertTimelineInterval $parent, intervalArray

			addSwipeEventHandlers $parent, options

			# addTimeSlots $parent, options.timeArray


	class Timeline
		constructor : ( options )->
			
			render.call @, options

			@.on 'refresh',=>
				
				render.call @, options


		

			











	if TEST_ENV?
		# root.hasChild = hasChild
		root.createChildRegion = createChildRegion
		root.validateSameDayTime = validateSameDayTime
		root.getStartTime = getStartTime
		root.getEndTime = getEndTime
		root.getHourArray = getHourArray
		root.getAllowedIntervalLabel = getAllowedIntervalLabel
		root.getPixelPerSecond = getPixelPerSecond


		root.validateTimeArray = validateTimeArray

	$.fn.timeline = Timeline

).call @,jQuery