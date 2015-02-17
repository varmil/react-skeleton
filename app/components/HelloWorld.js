/** @jsx React.DOM */
var React = require('react');

var HelloWorld = React.createClass({
	displayName: 'HelloWorld',

	render: function () {
		return (
			<div>{this.props.message}</div>
		);
	}
});

module.exports = HelloWorld;