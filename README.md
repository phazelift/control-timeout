#control-timeout

####A timeout class for controlling one or multiple timeouts.

<br/>

###Features:

- register one or multiple timeouts within the same context
- start or stop a specific timeout, or all at once
- add to or remove timeouts from the context at any time
- have a common delay or override it for specific timeouts
- provides logs for invalid input errors, or can use your own preferred logger
- dynamically type safe

<br/>

---

###Usage

First install: `npm install --save control-timeout`

<br/>


```javascript
// require the class
var Timeout= require( 'control-timeout' );

// you can change the timeout class default overall fallback delay time of 0 seconds
Timeout.delay= 10000; // milliseconds

// create a timeout instance/context and override the class default delay by
// passing a delay time that will be used as a fallback for all timeouts only in this instance
var timeout= new Timeout( 3000 );

// add a timeout to the context without running it right away
var first= timeout.add({
	 id		: 'first'
	 // declare an action to be taken in case the timeout is reached
	,action	: () => console.log( 'first timeout has been triggered' )
});

// run it only when you need it
// this will start the timeout using the default context's 3000ms delay time
timeout.run( 'first' );
// first timeout has been triggered

// add a second timeout, this time overriding the default context delay
var second= timeout.add({
	 id		: 'second'
	 // receive arguments passed by .run()
	,action	: ( msg1, msg2 ) => console.log( 'second timeout, message:', msg1+ msg2 )
	// override the context default delay time for this specific timeout
	,delay	: 1000
});

// pass arguments to the timeout via the run method, after the id argument
timeout.run( 'second', 'hello arguments', '!')
// second timeout, message: hello arguments!


// calling run with a falsey first argument causes to start all timeouts in the context
timeout.run( null, 'generic', ' message..' );

// you can stop one or multiple timeouts from running
timeout.stop( 'first', 'second' );

// or you can stop all by not giving a specific name
timeout.stop();

// you can remove one or multiple timeouts from the context with remove
timeout.remove( 'first', 'second' );

// NOTE: removing timeouts also stops them if they are running

// or remove all registered timeouts at once
timeout.removeAll()


// you can also add a timeout like this
timeout.add( 'third', () => timeout.stop('first'), 2000 );


// you can change the delay of a specific timeout for it's following runs
timeout.setDelay( 'first', 1000 );


// you can change the default log method by passing a custom handler
Timeout.setLog( (err) => {
	console.log( 'my custom input error handler', err );
});

// or turn logging of by calling setLog without arguments
Timeout.setLog();

```

The raw native setTimeout return value is only available after the .run mehtod has been called. So, if for some reason you need it, take run's return value:
```javascript
// the run method returns the raw timeout
var rawSecond= timeout.run( 'second' );

// or all timeouts that are running, in an array
var timeouts= timeout.run();

// use getTimeout to get the raw timeout value of a running timeout
var rawFirst= timeout.getTimeout( 'first' );
```

---

change log
==========


**0.1.0**

- .add prototype now returns the context
- adds babel transpiler as dev dependency for better cross browser compatibility

---

###license

MIT

---