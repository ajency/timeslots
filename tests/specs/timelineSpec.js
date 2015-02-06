describe('Timeline testing', function() {
  var globalArr;
  globalArr = [];
  beforeEach(function() {
    return globalArr = [1422523800, 1422526800, 1422528000, 1422534600, 1422538200, 1422541800, 1422546400, 1422552600];
  });
  describe('validateSameDayTime()', function() {
    return it('checks if the time in the array belongs to same day', function() {
      var arr;
      arr = [1422526800, 1422528000, 1422534600];
      expect(validateSameDayTime(arr)).toBe(true);
      arr = [1422526800, 1422528000, 1422134600];
      return expect(validateSameDayTime(arr)).toBe(false);
    });
  });
  describe('validateTimeArray()', function() {
    it('checks that argument passed is an array', function() {
      var arr, obj;
      arr = [1422528000, 1422534600, 1422538200];
      expect(validateTimeArray(arr)).toBe(true);
      obj = {
        a: 2,
        b: 4
      };
      expect(validateTimeArray(obj)).toBe(false);
      return expect(validateTimeArray(1422534600)).toBe(false);
    });
    it('checks that array length is greater then or equal to 2', function() {
      var arr, arr2;
      arr = [1422528000, 1422534600, 1422538200];
      expect(validateTimeArray(arr)).toBe(true);
      arr2 = [1422534600];
      return expect(validateTimeArray(arr2)).toBe(false);
    });
    it('checks that array consists of valid dates between 1/1/2010 and now', function() {
      var arr, arr2;
      arr = [1, 3343534, 23, 45];
      expect(validateTimeArray(arr)).toBe(false);
      arr2 = [1422526800, 1422528000, 1422534600, 1422538200, 1422541800];
      return expect(validateTimeArray(arr2)).toBe(true);
    });
    return it('all dates must belong to same day', function() {
      var arr;
      arr = [1422526800, 1422528000, 1422534600, 1422538200, 1422541800];
      expect(validateTimeArray(arr)).toBe(true);
      arr = [1422526800, 1422528000, 1422134600, 1422538200, 1422541800];
      return expect(validateTimeArray(arr)).toBe(false);
    });
  });
  describe('createChildRegion()', function() {
    var $parent;
    $parent = $('<div class="parent"></div>');
    return it('creates the necessary regions for timeline', function() {
      createChildRegion($parent);
      expect($parent).toContainElement('div.timeline');
      return expect($parent).toContainElement('div.time-description');
    });
  });
  describe('getStartTime()', function() {
    var arr;
    arr = [1422526800, 1422528000, 1422534600, 1422538200, 1422541800];
    return it('returns the first array item as start time', function() {
      return expect(getStartTime(arr)).toEqual(1422526800);
    });
  });
  describe('getEndTime()', function() {
    var arr;
    arr = [1422526800, 1422528000, 1422534600, 1422538200, 1422541800];
    return it('returns the last array item as end time', function() {
      return expect(getEndTime(arr)).toEqual(1422541800);
    });
  });
  describe('getHourArray()', function() {
    return it('returns the hour array in specified format', function() {
      var arr, response;
      arr = [1422523800, 1422526800, 1422528000, 1422534600, 1422538200, 1422541800, 1422546400, 1422552600];
      response = [
        {
          "label": "4pm",
          "percentage": 12.5
        }, {
          "label": "5pm",
          "percentage": 25
        }, {
          "label": "6pm",
          "percentage": 37.5
        }, {
          "label": "7pm",
          "percentage": 50
        }, {
          "label": "8pm",
          "percentage": 62.5
        }, {
          "label": "9pm",
          "percentage": 75
        }, {
          "label": "10pm",
          "percentage": 87.5
        }
      ];
      return expect(getHourArray(arr)).toEqual(response);
    });
  });
  describe('getAllowedIntervalLabel()', function() {
    return it('gets the correct allowed index', function() {
      return expect(getAllowedIntervalLabel(300, 24)).toEqual([4, 8, 12, 16, 20, 24]);
    });
  });
  return describe('getPixelPerSecond()', function() {
    return it('get the pixel for a second', function() {
      expect(getPixelPerSecond(globalArr, 600)).toEqual(0.03333333333333333);
      return expect(getPixelPerSecond(globalArr, 1200)).toEqual(0.041666666666666664);
    });
  });
});
