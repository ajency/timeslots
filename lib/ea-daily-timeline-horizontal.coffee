( ($)->

	root = @
	usedColors = []

	doesClassExists = ($parent,className)->
		$parent.find(".#{className}").length > 0

	createDivWithClass = ($parent,className)->
		$parent.append "<div class='#{className}'></div>"

	checkIfDatesBelongToSameDay = (timeArray)->
		for time in timeArray
			if date and date isnt moment.unix(time).format('L')
				return false
			else
				date = moment.unix(time).format('L')
		true

	getStartTime  = (timeArray)->
		timeArray[0] 

	getEndTime = (timeArray)->
		timeArray[timeArray.length-1]

	getHourArray = (startTime,endTime)->
		intervalArray = []
		startHour = moment.unix(startTime).hour()
		endHour = moment.unix(endTime).hour()
		totalSeconds = endTime - startTime
		intervalHour = startHour + 1
		intervalMoment = moment.unix(startTime)
		while intervalHour <= endHour
			intervalMoment.hour(intervalHour)
			intervalTime = intervalMoment.unix()
			intervalSeconds = intervalTime - startTime
			intervalPercent = intervalSeconds * 100 / totalSeconds
			intervalLabel = intervalMoment.format('ha');
			if intervalPercent > 5 and intervalPercent < 95
				intervalArray.push 
					label : intervalLabel
					percentage : intervalPercent
			intervalHour += 1 
		intervalArray

	insertTimelineInterval = ($parent, intervalArray)->
		$parent.find('.timeline').append '<div class="overflow-timeline">
					<div class="timeline-interval-region" style="height: 25px; position: relative;"></div>
				</div>'
		width = $parent.find('.timeline-interval-region').width()
		allowedInterval = (width / 50) - 1
		actualIntervalLength = intervalArray.length
		while actualIntervalLength > allowedInterval
			actualIntervalLength = Math.ceil actualIntervalLength/2

		for interval,i in intervalArray
			
			if (i+1)%(Math.ceil(intervalArray.length/actualIntervalLength)) 
				console.log (i+1)%(Math.ceil(intervalArray.length/actualIntervalLength))
				continue
			left = (interval.percentage * width / 100)-20
			$parent.find('.timeline-interval-region').append "<div class='time-interval' style='left : #{interval.percentage}%'><div>#{interval.label}</div></div>"

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


	addTimeSlots = ($parent, timeArray)->
		$parent.find('.overflow-timeline').append '<div class="timeline-slot-region"></div>'

		width = $parent.find('.timeline-interval-region').width()

		pixelPerSecond = getPixelPerSecond timeArray,width
		for time,i in timeArray
			if i is 0
				$parent.find('.timeline-slot-region').append "<div  class='slot-interval' ><div class='slot-interval-time first'>#{moment.unix(time).format('H:mm')}</div></div>"
				continue

			slotTime = time - timeArray[i-1]
			totalTime = timeArray[timeArray.length-1] - timeArray[0]
			percentage = Math.floor(slotTime * pixelPerSecond)
			color = getRandomColor()
			$parent.find('.timeline-slot-region').append "<div data-slot='#{i-1}' class='slot' style='background-color: #{color}; width: #{percentage}px'></div>"
			addDescription $parent,timeArray[i-1],time,color,i-1
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
						console.log positionLeft
						ui.position.left = outerWidth - innerWidth
						# $( ".overflow-timeline" ).css 'left', (outerWidth - innerWidth) + 'px'
					if positionLeft > 0
						console.log positionLeft
						ui.position.left = 0

						$( ".overflow-timeline" ).css 'left', '0px'

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

	getRandomColor = ->
		letters = '789ABCDEF'.split('');
		color = '#';
		for i in [1..3]
			color += letters[Math.floor(Math.random() * 9)];
			color += 'A'

		if color in usedColors
			color = getRandomColor()
		
		color;




	class Timeline
		constructor : ($parent, timeArray)->
			if not ($parent instanceof jQuery)
				throw "please give a jquery object"

			if not doesClassExists $parent, 'timeline'
				createDivWithClass $parent, 'timeline'
			if not doesClassExists $parent, 'time-description'
				createDivWithClass $parent, 'time-description'

			$parent.find('.timeline').css 
					'width':'100%'
					'overflow-x' : 'hidden'


			if timeArray.length < 2
				throw "Please give time array greater then or equal to 2"

			if not checkIfDatesBelongToSameDay timeArray
				throw "all time must belong to same day"

			# sort time array in asscending order
			timeArray.sort()

			@startTime = getStartTime timeArray
			@endTime = getEndTime timeArray

			intervalArray = getHourArray @startTime, @endTime

			# add hourly ime interval
			insertTimelineInterval $parent, intervalArray

			addTimeSlots $parent, timeArray

			











	if TEST_ENV?
		root.doesClassExists = doesClassExists
		root.createDivWithClass = createDivWithClass
		root.checkIfDatesBelongToSameDay = checkIfDatesBelongToSameDay
		root.getStartTime = getStartTime
		root.getEndTime = getEndTime
		root.getHourArray = getHourArray

	root.Timeline = Timeline

).call @,jQuery