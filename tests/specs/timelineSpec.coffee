describe 'Timeline testing',->
	globalArr = []

	beforeEach ->
		globalArr = [1422523800,1422526800,1422528000,1422534600,
				1422538200,1422541800,1422546400,1422552600]


	describe 'validateSameDayTime()',->
		it 'checks if the time in the array belongs to same day',->
			arr = [1422526800,1422528000,1422534600]
			expect(validateSameDayTime(arr)).toBe(true)
			arr = [1422526800,1422528000,1422134600]
			expect(validateSameDayTime(arr)).toBe(false)

	describe 'validateTimeArray()',->

		it 'checks that argument passed is an array',->
			arr = [1422528000,1422534600,1422538200]
			expect(validateTimeArray(arr)).toBe(true)
			obj = {a:2,b:4}
			expect(validateTimeArray(obj)).toBe(false)
			expect(validateTimeArray(1422534600)).toBe(false)

		it 'checks that array length is greater then or equal to 2',->
			arr = [1422528000,1422534600,1422538200]
			expect(validateTimeArray(arr)).toBe(true)
			arr2 = [1422534600]
			expect(validateTimeArray(arr2)).toBe(false)

		it 'checks that array consists of valid dates between 1/1/2010 and now', ->

			arr = [1,3343534,23,45]
			expect(validateTimeArray(arr)).toBe(false)
			arr2 = [1422526800,1422528000,1422534600,1422538200,1422541800]
			expect(validateTimeArray(arr2)).toBe(true)

		it 'all dates must belong to same day',->
			arr = [1422526800,1422528000,1422534600,1422538200,1422541800]
			expect(validateTimeArray(arr)).toBe(true)
			arr = [1422526800,1422528000,1422134600,1422538200,1422541800]
			expect(validateTimeArray(arr)).toBe(false)

	describe 'createChildRegion()', ->		
		$parent = $('<div class="parent"></div>')

		it 'creates the necessary regions for timeline',->
			createChildRegion $parent
			expect($parent).toContainElement('div.timeline')
			expect($parent).toContainElement('div.time-description')


	describe 'getStartTime()',->
		arr = [1422526800,1422528000,1422534600,1422538200,1422541800]

		it 'returns the first array item as start time',->
			expect(getStartTime(arr)).toEqual(1422526800)

	describe 'getEndTime()',->
		arr = [1422526800,1422528000,1422534600,1422538200,1422541800]

		it 'returns the last array item as end time',->
			expect(getEndTime(arr)).toEqual(1422541800)


	describe 'getHourArray()',->

		it 'returns the hour array in specified format',->

			arr = [1422523800,1422526800,1422528000,1422534600,
				1422538200,1422541800,1422546400,1422552600]

			response = [{"label":"4pm","percentage":12.5},{"label":"5pm","percentage":25},
						{"label":"6pm","percentage":37.5},{"label":"7pm","percentage":50},
						{"label":"8pm","percentage":62.5},{"label":"9pm","percentage":75},
						{"label":"10pm","percentage":87.5}]

			expect(getHourArray(arr)).toEqual(response)

	describe 'getAllowedIntervalLabel()',->

		it 'gets the correct allowed index',->
			
			expect(getAllowedIntervalLabel(300,24)).toEqual([4,8,12,16,20,24])


	describe 'getPixelPerSecond()',->

		it 'get the pixel for a second',->

			expect(getPixelPerSecond(globalArr,600)).toEqual(0.03333333333333333)
			expect(getPixelPerSecond(globalArr,1200)).toEqual(0.041666666666666664)