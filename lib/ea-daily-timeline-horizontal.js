var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

(function($) {
  var Timeline, addDescription, addSwipeEventHandlers, addTimeSlots, combineSlots, createChildRegion, getAllowedIntervalLabel, getCurrentTimestamp, getEndTime, getHourArray, getPixelPerSecond, getRandomColor, getStartTime, index, insertTimelineInterval, render, root, stopCombineSlot, usedColors, validateSameDayTime, validateTimeArray;
  root = this;
  usedColors = [];
  addTimeSlots = function($parent, options) {
    var color, i, percentage, pixelPerSecond, slotTime, time, timeArray, totalTime, width, _i, _len;
    timeArray = options.timeArray;
    width = $parent.find('.timeline-interval-region').width();
    pixelPerSecond = getPixelPerSecond(timeArray, width);
    for (i = _i = 0, _len = timeArray.length; _i < _len; i = ++_i) {
      time = timeArray[i];
      if (i === 0) {
        if (options.showStartEndTimes) {
          $parent.find('.timeline-slot-region').append("<div  class='slot-interval' > <div class='slot-interval-time first'> " + (moment.unix(time).format('H:mm')) + " </div> </div>");
        }
        continue;
      }
      slotTime = time - timeArray[i - 1];
      totalTime = timeArray[timeArray.length - 1] - timeArray[0];
      percentage = Math.floor(slotTime * pixelPerSecond);
      color = getRandomColor();
      $parent.find('.timeline-slot-region').append("<div data-slot='" + (i - 1) + "' class='slot' style='background-color: " + color + "; width: " + percentage + "px'></div>");
      addDescription($parent, timeArray[i - 1], time, color, i - 1);
      if (options.showStartEndTimes) {
        if (i < timeArray.length - 1) {
          $parent.find('.timeline-slot-region').append("<div  class='slot-interval' ><div class='slot-interval-time'>" + (moment.unix(time).format('H:mm')) + "</div></div>");
        } else {
          $parent.find('.timeline-slot-region').append("<div  class='slot-interval' ><div class='slot-interval-time last'>" + (moment.unix(time).format('H:mm')) + "</div></div>");
        }
      }
    }
    $(".overflow-timeline").draggable({
      axis: 'x',
      scroll: false,
      drag: function(e, ui) {
        var innerWidth, outerWidth, positionLeft;
        e.stopPropagation();
        innerWidth = $(".overflow-timeline").width();
        outerWidth = $(".overflow-timeline").parent().width();
        positionLeft = ui.position.left;
        if (positionLeft < outerWidth - innerWidth) {
          ui.position.left = outerWidth - innerWidth;
        }
        if (positionLeft > 0) {
          return ui.position.left = 0;
        }
      }
    });
    return $(".overflow-timeline").css('display', 'inline-table');
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
  index = [1, 1, 1, 1, 1, 1];
  getRandomColor = function() {
    var color, i, letters, val, _i;
    letters = '6789ABCDEF'.split('');
    color = '#';
    for (i = _i = 0; _i <= 5; i = ++_i) {
      if (i % 2) {
        index[i] = (index[i] + Math.floor(Math.random() * 10)) % 10;
      } else {
        val = (index[i] - Math.floor(Math.random() * 10)) % 10;
        index[i] = val < 0 ? 10 + val : val;
      }
      color += letters[index[i]];
    }
    if (__indexOf.call(usedColors, color) < 0) {
      usedColors.push(color);
    } else {
      color = getRandomColor();
    }
    return color;
  };
  validateSameDayTime = function(timeArray) {
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
  validateTimeArray = function(timeArray) {
    var currentTime, time, _i, _len;
    if (!Array.isArray(timeArray)) {
      return false;
    }
    if (timeArray.length < 2) {
      return false;
    }
    currentTime = getCurrentTimestamp();
    for (_i = 0, _len = timeArray.length; _i < _len; _i++) {
      time = timeArray[_i];
      if (time < 1262304000 || time > currentTime) {
        return false;
      }
    }
    if (!validateSameDayTime(timeArray)) {
      return false;
    }
    return true;
  };
  getCurrentTimestamp = function() {
    var timestamp;
    timestamp = (new Date()).getTime() / 1000;
    return Math.floor(timestamp);
  };
  createChildRegion = function($parent) {
    return $parent.html("	<div class='timeline'> <div class='overflow-timeline'> <div class='timeline-interval-region' style='height: 25px; position: relative;'></div> <div class='timeline-slot-region'></div> </div> </div> <div class='time-description'></div>");
  };
  getStartTime = function(timeArray) {
    return timeArray[0];
  };
  getEndTime = function(timeArray) {
    return timeArray[timeArray.length - 1];
  };
  getHourArray = function(timeArray) {
    var endHour, endTime, intervalArray, intervalLabel, intervalPercent, intervalSeconds, startHour, startTime, tempHour, tempMoment, tempTime, totalSeconds;
    startTime = getStartTime(timeArray);
    endTime = getEndTime(timeArray);
    intervalArray = [];
    startHour = moment.unix(startTime).hour();
    endHour = moment.unix(endTime).hour();
    totalSeconds = endTime - startTime;
    tempHour = startHour + 1;
    tempMoment = moment.unix(startTime);
    while (tempHour <= endHour) {
      tempMoment.hour(tempHour);
      tempTime = tempMoment.unix();
      intervalSeconds = tempTime - startTime;
      intervalPercent = intervalSeconds * 100 / totalSeconds;
      intervalLabel = tempMoment.format('ha');
      if (intervalPercent > 5 && intervalPercent < 95) {
        intervalArray.push({
          label: intervalLabel,
          percentage: intervalPercent
        });
      }
      tempHour += 1;
    }
    return intervalArray;
  };
  insertTimelineInterval = function($parent, intervalArray) {
    var allowedIndices, i, interval, left, width, _i, _len, _ref, _results;
    width = $parent.find('.timeline-interval-region').width();
    allowedIndices = getAllowedIntervalLabel(width, intervalArray.length);
    _results = [];
    for (i = _i = 0, _len = intervalArray.length; _i < _len; i = ++_i) {
      interval = intervalArray[i];
      if (_ref = i + 1, __indexOf.call(allowedIndices, _ref) >= 0) {
        left = (interval.percentage * width / 100) - 20;
        _results.push($parent.find('.timeline-interval-region').append("<div class='time-interval' style='left : " + interval.percentage + "%'><div>" + interval.label + "</div></div>"));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };
  getAllowedIntervalLabel = function(width, actualNumberOfLabels) {
    var allowedIndex, allowedNumberOfLabels, divisor, i, tempNumberOfLabels, _i;
    allowedNumberOfLabels = width / 50;
    tempNumberOfLabels = actualNumberOfLabels;
    divisor = Math.ceil(actualNumberOfLabels / allowedNumberOfLabels);
    allowedIndex = [];
    for (i = _i = 1; 1 <= actualNumberOfLabels ? _i <= actualNumberOfLabels : _i >= actualNumberOfLabels; i = 1 <= actualNumberOfLabels ? ++_i : --_i) {
      if (i % divisor === 0 && i !== 0) {
        allowedIndex.push(i);
      }
    }
    return allowedIndex;
  };
  getPixelPerSecond = function(timeArray, width) {
    var i, pixelPerSecond, pps, ppsTotal, shortestSlot, time, _i, _len;
    shortestSlot = 100000;
    for (i = _i = 0, _len = timeArray.length; _i < _len; i = ++_i) {
      time = timeArray[i];
      if (i === 0) {
        continue;
      }
      if (shortestSlot > time - timeArray[i - 1]) {
        shortestSlot = time - timeArray[i - 1];
      }
    }
    pps = 40 / shortestSlot;
    ppsTotal = width / (timeArray[timeArray.length - 1] - timeArray[0]);
    pixelPerSecond = pps > ppsTotal ? pps : ppsTotal;
    return pixelPerSecond;
  };
  addSwipeEventHandlers = function($parent, options) {
    var $timeslotDescription;
    $timeslotDescription = $parent.find('.time-description .slot');
    $timeslotDescription.on('swiperight', function(e) {
      var duration, slotEnd, slotNo, slotStart;
      if ($(e.target).closest('.time-description').hasClass('combine-parent')) {
        return;
      }
      if (!$(e.target).hasClass('slot')) {
        return;
      }
      slotNo = parseInt($(e.target).attr('data-slot'));
      slotStart = options.timeArray[slotNo];
      slotEnd = options.timeArray[slotNo + 1];
      duration = moment.unix(slotEnd).diff(moment.unix(slotStart), 'minutes');
      console.log(duration);
      console.log('split');
      return bootbox.dialog({
        title: 'Create new slot',
        message: '<div> <span> Start time : ' + moment.unix(slotStart).format('h:mm a') + ' </span> </div><div> <span> End time : ' + moment.unix(slotEnd).format('h:mm a') + ' </span> </div> <div><span>Duration : ' + duration + ' minutes</span></div> <div class="split-time"> Enter new slot time <span> <input type="number" maxlength="2" min="0" max="24" class="new-slot"/> </span>  minutes <div> add new slot at the </br> <input type="radio" name="newSlotPosition" value="start" checked>Start <input type="radio" name="newSlotPosition" value="end">End </div> </div>',
        buttons: {
          cancel: {
            label: 'Cancel',
            className: 'btn-failure'
          },
          split: {
            label: 'Split',
            className: 'btn-primary',
            callback: function() {
              var newMoment, newMomentUnix, slotMinutes, timeMinutes;
              timeMinutes = parseInt($('.split-time .new-slot').val());
              slotMinutes = timeMinutes > 0 && timeMinutes < duration ? timeMinutes : '';
              if (slotMinutes === '') {
                return;
              }
              newMoment = moment.unix(slotStart);
              console.log($('input[name="newSlotPosition"]').val());
              if ($('input[name="newSlotPosition"]:checked').val() === 'end') {
                newMoment.add(duration - slotMinutes, 'm');
              } else {
                newMoment.add(slotMinutes, 'm');
              }
              newMomentUnix = newMoment.unix();
              if (newMomentUnix > slotStart && newMomentUnix < slotEnd) {
                options.timeArray.push(newMomentUnix);
                options.timeArray.sort();
                if ((options.onSplitSlot != null) && typeof options.onSplitSlot === 'function') {
                  options.onSplitSlot.call(this, options.timeArray);
                }
                return $parent.trigger('refresh');
              }
            }
          }
        }
      });
    });
    return $timeslotDescription.on('swipeleft', function(e) {
      var isFirst, isLast, slotNo;
      if ($(e.target).closest('.time-description').hasClass('combine-parent')) {
        return;
      }
      if (!$(e.target).hasClass('slot')) {
        return;
      }
      slotNo = parseInt($(e.target).attr('data-slot'));
      isFirst = slotNo === 0 ? true : false;
      isLast = slotNo === options.timeArray.length - 2 ? true : false;
      if (isFirst && isLast) {
        return;
      }
      $(e.target).closest('.time-description').addClass('combine-parent');
      $(e.target).addClass('combine-current');
      $(e.target).append('<span class="cancel-combine"><i class="glyphicon glyphicon-remove"></i></span>');
      if (!isFirst) {
        $('.time-description.combine-parent .slot[data-slot="' + (slotNo - 1) + '"]').addClass('combine-neighbour');
      }
      if (!isLast) {
        $('.time-description.combine-parent .slot[data-slot="' + (slotNo + 1) + '"]').addClass('combine-neighbour');
      }
      $('.time-description.combine-parent .slot.combine-neighbour').on('tap', combineSlots.bind(this, $parent, options, slotNo));
      return $('.time-description.combine-parent .slot.combine-current .cancel-combine').on('tap', stopCombineSlot.bind(this, $parent));
    });
  };
  combineSlots = function($parent, options, slotNo, e) {
    var neighbourSlot;
    console.log('combine');
    neighbourSlot = parseInt($(e.target).attr('data-slot'));
    if (neighbourSlot < slotNo) {
      options.timeArray.splice(slotNo, 1);
    } else if (neighbourSlot > slotNo) {
      options.timeArray.splice(slotNo + 1, 1);
    }
    stopCombineSlot($parent);
    if ((options.onCombineSlot != null) && typeof options.onCombineSlot === 'function') {
      options.onCombineSlot.call(this, options.timeArray);
    }
    return $parent.trigger('refresh');
  };
  stopCombineSlot = function($parent) {
    $('.time-description.combine-parent .slot.combine-current .cancel-combine').off().remove();
    $('.time-description.combine-parent .slot.combine-neighbour').off('tap').removeClass('combine-neighbour');
    $('.time-description.combine-parent .slot.combine-current').removeClass('combine-current');
    return $('.time-description.combine-parent ').removeClass('combine-parent');
  };
  render = function(options) {
    var $parent, intervalArray;
    $parent = this;
    if (!validateTimeArray(options.timeArray)) {
      throw 'The timeArray passed is not valid';
    }
    options.timeArray.sort();
    createChildRegion($parent);
    $parent.find('.timeline').css({
      'width': '100%',
      'overflow-x': 'hidden'
    });
    intervalArray = getHourArray(options.timeArray);
    addTimeSlots($parent, options);
    insertTimelineInterval($parent, intervalArray);
    return addSwipeEventHandlers($parent, options);
  };
  Timeline = (function() {
    function Timeline(options) {
      render.call(this, options);
      this.on('refresh', (function(_this) {
        return function() {
          return render.call(_this, options);
        };
      })(this));
    }

    return Timeline;

  })();
  if (typeof TEST_ENV !== "undefined" && TEST_ENV !== null) {
    root.createChildRegion = createChildRegion;
    root.validateSameDayTime = validateSameDayTime;
    root.getStartTime = getStartTime;
    root.getEndTime = getEndTime;
    root.getHourArray = getHourArray;
    root.getAllowedIntervalLabel = getAllowedIntervalLabel;
    root.getPixelPerSecond = getPixelPerSecond;
    root.validateTimeArray = validateTimeArray;
  }
  return $.fn.timeline = Timeline;
}).call(this, jQuery);
