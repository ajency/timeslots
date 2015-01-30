
describe "Test",->
	timeArray = []

	before ->
		timeArray = [1422523800,1422527400,1422531000,1422534600,
				1422538200,1422541800,1422545400,1422552600]


	describe 'doesClassExists()',->
		parent = null
		before ->
			parent = $('<div ><div class="timeline"></div><div class="time-description"></div> </div>')

		it 'has a class called "timeline"',->
			(doesClassExists(parent,'timeline')).should.be.ok

		it 'has a class called "time-description"',->
			(doesClassExists(parent,'time-description')).should.be.ok


	describe 'createDivWithClass',->
		parent = null

		before ->
			parent = $('<div></div>')

		it 'successuflly created a div with class "timeline"',->
			createDivWithClass parent,'timeline'
			(doesClassExists(parent,'timeline')).should.be.ok

		it 'successuflly created a div with class "time-description"',->
			createDivWithClass parent,'time-description'
			(doesClassExists(parent,'time-description')).should.be.ok

	describe 'checkIfDatesBelongToSameDay()',->

		


		it "all time belongs to same day",->
			console.log timeArray.length
			(checkIfDatesBelongToSameDay(timeArray)).should.be.true


		it "all time doesnt belong to same day",->
			timeArray.push 1422356200
			(checkIfDatesBelongToSameDay(timeArray)).should.be.false

		after ->
			timeArray.pop()


	describe 'getStartTime()',->

		it 'get first time as start time',->
			(getStartTime(timeArray)).should.be.exactly(timeArray[0])

	describe 'getEndTime()',->

		it 'get last time as end time',->
			(getEndTime(timeArray)).should.be.exactly(timeArray[timeArray.length-1])

	describe 'getHourArray()',->

		it 'gets hour array',->
			(getHourArray(timeArray[0], timeArray[timeArray.length-1])).should.have.a.lengthOf(7)
			(getHourArray(timeArray[0], timeArray[timeArray.length-1])).should.be.an.instanceOf(Array)
			(getHourArray(timeArray[0], timeArray[timeArray.length-1])[0]).should.be.an.Object
			(getHourArray(timeArray[0], timeArray[timeArray.length-1])[0]).should.have.properties({
															label: "4pm",
															percentage: 12.5})




			