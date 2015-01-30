describe("Test", function() {
  var timeArray;
  timeArray = [];
  before(function() {
    return timeArray = [1422523800, 1422527400, 1422531000, 1422534600, 1422538200, 1422541800, 1422545400, 1422552600];
  });
  describe('doesClassExists()', function() {
    var parent;
    parent = null;
    before(function() {
      return parent = $('<div ><div class="timeline"></div><div class="time-description"></div> </div>');
    });
    it('has a class called "timeline"', function() {
      return (doesClassExists(parent, 'timeline')).should.be.ok;
    });
    return it('has a class called "time-description"', function() {
      return (doesClassExists(parent, 'time-description')).should.be.ok;
    });
  });
  describe('createDivWithClass', function() {
    var parent;
    parent = null;
    before(function() {
      return parent = $('<div></div>');
    });
    it('successuflly created a div with class "timeline"', function() {
      createDivWithClass(parent, 'timeline');
      return (doesClassExists(parent, 'timeline')).should.be.ok;
    });
    return it('successuflly created a div with class "time-description"', function() {
      createDivWithClass(parent, 'time-description');
      return (doesClassExists(parent, 'time-description')).should.be.ok;
    });
  });
  describe('checkIfDatesBelongToSameDay()', function() {
    it("all time belongs to same day", function() {
      console.log(timeArray.length);
      return (checkIfDatesBelongToSameDay(timeArray)).should.be["true"];
    });
    it("all time doesnt belong to same day", function() {
      timeArray.push(1422356200);
      return (checkIfDatesBelongToSameDay(timeArray)).should.be["false"];
    });
    return after(function() {
      return timeArray.pop();
    });
  });
  describe('getStartTime()', function() {
    return it('get first time as start time', function() {
      return (getStartTime(timeArray)).should.be.exactly(timeArray[0]);
    });
  });
  describe('getEndTime()', function() {
    return it('get last time as end time', function() {
      return (getEndTime(timeArray)).should.be.exactly(timeArray[timeArray.length - 1]);
    });
  });
  return describe('getHourArray()', function() {
    return it('gets hour array', function() {
      (getHourArray(timeArray[0], timeArray[timeArray.length - 1])).should.have.a.lengthOf(7);
      (getHourArray(timeArray[0], timeArray[timeArray.length - 1])).should.be.an.instanceOf(Array);
      (getHourArray(timeArray[0], timeArray[timeArray.length - 1])[0]).should.be.an.Object;
      return (getHourArray(timeArray[0], timeArray[timeArray.length - 1])[0]).should.have.properties({
        label: "4pm",
        percentage: 12.5
      });
    });
  });
});
