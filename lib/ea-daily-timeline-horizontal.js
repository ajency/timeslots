var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

(function($) {
  var Timeline, addDescription, addTimeSlots, checkIfDatesBelongToSameDay, createDivWithClass, doesClassExists, getEndTime, getHourArray, getRandomColor, getStartTime, insertTimelineInterval, root, usedColors;
  root = this;
  usedColors = [];
  doesClassExists = function($parent, className) {
    return $parent.find("." + className).length > 0;
  };
  createDivWithClass = function($parent, className) {
    return $parent.append("<div class='" + className + "'></div>");
  };
  checkIfDatesBelongToSameDay = function(timeArray) {
    var date, time, _i, _len;
    for (_i = 0, _len = timeArray.length; _i < _len; _i++) {
      time = timeArray[_i];
      if (date && date !== moment.unix(time).format('L')) {
        return false;
      } else {
        date = moment.unix(time).format('L');
      }
    }
    return true;
  };
  getStartTime = function(timeArray) {
    return timeArray[0];
  };
  getEndTime = function(timeArray) {
    return timeArray[timeArray.length - 1];
  };
  getHourArray = function(startTime, endTime) {
    var endHour, intervalArray, intervalHour, intervalLabel, intervalMoment, intervalPercent, intervalSeconds, intervalTime, startHour, totalSeconds;
    intervalArray = [];
    startHour = moment.unix(startTime).hour();
    endHour = moment.unix(endTime).hour();
    totalSeconds = endTime - startTime;
    intervalHour = startHour + 1;
    intervalMoment = moment.unix(startTime);
    while (intervalHour <= endHour) {
      intervalMoment.hour(intervalHour);
      intervalTime = intervalMoment.unix();
      intervalSeconds = intervalTime - startTime;
      intervalPercent = intervalSeconds * 100 / totalSeconds;
      intervalLabel = intervalMoment.format('ha');
      if (intervalPercent > 5 && intervalPercent < 95) {
        intervalArray.push({
          label: intervalLabel,
          percentage: intervalPercent
        });
      }
      intervalHour += 1;
    }
    return intervalArray;
  };
  insertTimelineInterval = function($parent, intervalArray) {
    var actualIntervalLength, allowedInterval, i, interval, left, width, _i, _len, _results;
    $parent.find('.timeline').append('<div class="timeline-interval-region"></div>');
    width = $parent.find('.timeline .timeline-interval-region').width();
    allowedInterval = (width / 50) - 1;
    actualIntervalLength = intervalArray.length;
    while (actualIntervalLength > allowedInterval) {
      actualIntervalLength = Math.ceil(actualIntervalLength / 2);
    }
    _results = [];
    for (i = _i = 0, _len = intervalArray.length; _i < _len; i = ++_i) {
      interval = intervalArray[i];
      if ((i + 1) % (Math.ceil(intervalArray.length / actualIntervalLength))) {
        console.log((i + 1) % (Math.ceil(intervalArray.length / actualIntervalLength)));
        continue;
      }
      left = (interval.percentage * width / 100) - 20;
      _results.push($parent.find('.timeline-interval-region').append("<div class='time-interval' style='left : " + interval.percentage + "%'><div>" + interval.label + "</div></div>"));
    }
    return _results;
  };
  addTimeSlots = function($parent, timeArray) {
    var color, i, percentage, slotTime, time, totalTime, _i, _len, _results;
    $parent.find('.timeline').append('<div class="timeline-slot-region"></div>');
    _results = [];
    for (i = _i = 0, _len = timeArray.length; _i < _len; i = ++_i) {
      time = timeArray[i];
      if (i === 0) {
        continue;
      }
      slotTime = time - timeArray[i - 1];
      totalTime = timeArray[timeArray.length - 1] - timeArray[0];
      percentage = slotTime * 100 / totalTime;
      color = getRandomColor();
      $parent.find('.timeline-slot-region').append("<div data-slot='" + (i - 1) + "' class='slot' style='background-color: " + color + "; width: " + percentage + "%'></div>");
      _results.push(addDescription($parent, timeArray[i - 1], time, color, i - 1));
    }
    return _results;
  };
  addDescription = function($parent, slotStart, slotEnd, color, slotId) {
    var diff, duration;
    duration = moment.unix(slotEnd).diff(slotStart * 1000);
    diff = '';
    if (moment.duration(duration).hours()) {
      diff += "" + (moment.duration(duration).hours()) + " hr";
    }
    if (moment.duration(duration).hours() && moment.duration(duration).minutes()) {
      diff += ', ';
    }
    if (moment.duration(duration).minutes()) {
      diff += "" + (moment.duration(duration).minutes()) + " min";
    }
    return $parent.find('.time-description').append("<div data-slot='" + slotId + "' class='slot'><div class='slot-time' style='background-color:" + color + "'>" + diff + "</div></div>");
  };
  getRandomColor = function() {
    var color, i, letters, _i;
    letters = '789ABCDEF'.split('');
    color = '#';
    for (i = _i = 1; _i <= 3; i = ++_i) {
      color += letters[Math.floor(Math.random() * 9)];
      color += 'A';
    }
    if (__indexOf.call(usedColors, color) >= 0) {
      color = getRandomColor();
    }
    return color;
  };
  Timeline = (function() {
    function Timeline($parent, timeArray) {
      var intervalArray;
      if (!($parent instanceof jQuery)) {
        throw "please give a jquery object";
      }
      if (!doesClassExists($parent, 'timeline')) {
        createDivWithClass($parent, 'timeline');
      }
      if (!doesClassExists($parent, 'time-description')) {
        createDivWithClass($parent, 'time-description');
      }
      if (timeArray.length < 2) {
        throw "Please give time array greater then or equal to 2";
      }
      if (!checkIfDatesBelongToSameDay(timeArray)) {
        throw "all time must belong to same day";
      }
      timeArray.sort();
      this.startTime = getStartTime(timeArray);
      this.endTime = getEndTime(timeArray);
      intervalArray = getHourArray(this.startTime, this.endTime);
      insertTimelineInterval($parent, intervalArray);
      addTimeSlots($parent, timeArray);
    }

    return Timeline;

  })();
  if (typeof TEST_ENV !== "undefined" && TEST_ENV !== null) {
    root.doesClassExists = doesClassExists;
    root.createDivWithClass = createDivWithClass;
    root.checkIfDatesBelongToSameDay = checkIfDatesBelongToSameDay;
    root.getStartTime = getStartTime;
    root.getEndTime = getEndTime;
    root.getHourArray = getHourArray;
  }
  return root.Timeline = Timeline;
}).call(this, jQuery);
