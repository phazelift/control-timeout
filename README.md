#control-timeout

####A timeout class for controlling one or multiple timeouts.

<br/>

###Features:

- create one or multiple timeouts within the same context
- have a common delay or override it for specific timeouts
- start and stop one or all timeouts at once
- remove timeouts from the context
- can substitute setInterval for node.js
- dynamically type safe

<br/>

---

###Usage

First install: `npm install --save control-timeout`

<br/>


```javascript
var Timeout= require( 'control-timeout' );

// create a timeout instance/context with a default timeout of 3 seconds
var timeout= new Timeout( 3000 );

// add a timeout to the context without running it right away
timeout.add({
	 id		: 'first'
	 // declare an action to be taken in case the timeout is reached
	,action	: () => console.log( 'first timeout has been triggered' )
	 // override the context timeout for this specific timeout
	,delay	: 4000
});

// create a timeout that will remove another one on timeout
timeout.add({
	  id		: 'cancel-first'
	 ,action	: timeout.remove.bind( timeout, 'first' )
});


// simulate setInterval, but controll times
var count= 0;
var times= 3;

timeout.add({
	 id		: times+ '-times'
	,action	: function(){
		console.log( ++count+ '/'+ times );
		if ( count < times ) timeout.run( times+ '-times' )
	}
	,delay	: 1000
});

// can add like this too
timeout.add( 'test', () => console.log('will I run?') );

// run all timeouts for this context
timeout.run();
// 1/3
// 2/3
// 3/3

// stop and remove test from context
timeout.remove( 'test' );

// etc..
```

---

I will add complete API and some more examples soon.

---

###license

MIT

---