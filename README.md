# ea-daily-timeline-horizontal
per day horizontal timeline to show the different timeslots in different colors

# Dependency
<ul>
<li><a href="http://jquery.com">jquery</a></li>
<li><a href="http://momentjs.com">moment.js</a></li>
<li><a href="http://jqueryui.com">jquery ui (draggable)</a></li>
<li><a href="http://touchpunch.furf.com/">jquery ui touch punch</a></li>
<li><a href="https://github.com/benmajor/jQuery-Touch-Events">jquery touch events</a></li>
<li><a href="http://getbootstrap.com/">bootstrap(modal)</a></li>
<li><a href="http://bootboxjs.com/">bootbox</a></li>

<ul>


# usage

```sh  
<script>
	$('.app').timeline({
		timeArray : [1422523800,1422526800,1422528000,1422534600,1422538200,1422541800,1422546400,1422552600],
		showStartEndTimes : true,
		onSplitSlot : function(timeArray){
			console.log(timeArray);
		},
		onCombineSlot : function(timeArray){
			console.log(timeArray);
		}
	})
</script>
```

### timeArray 
(required)<br/>
array of the times in unix timestamp . minimum length should be 2

### showSlotTimes
(optional)<br/>
default  = true<br/>
show times for slot change

### onSplitSlot
(optional)<br/>
callback when split is done<br/>
is given the new timearray

### onCombineSlot
(optional)<br/>
callback when combine is done<br/>
is given the new timearray
