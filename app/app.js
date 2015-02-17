var React = require('react');
var HelloWorld = require('./components/HelloWorld');

// React.render() instantiates the root component, starts the framework, and injects the markup
// into a raw DOM element, provided as the second argument.
React.render(
	<HelloWorld message='Hellooo' />,
	document.getElementById('content')
);
