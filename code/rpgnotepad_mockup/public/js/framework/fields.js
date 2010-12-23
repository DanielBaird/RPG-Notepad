
// *********************
// UniqueId - Constructor

// All functions that require a unique id (used for form elelements) 
// will inherit from this object.
// It will provide basic ID tracking.
function UniqueId() { 
	// Initialise the class variable UniqueId.id if it isn't already set
	// The if will only execute the first time someone creates
	// an instance of UniqueId
	if ( UniqueId.id == null ) {
		UniqueId.id = 1;                    // Start at 1, the first id provided to an instance will be 1, not 0.
	}

	// Set the instance id to be the next available id
	this.id = UniqueId.id++;
}

// *********************
// Text Field - Constructor

// A text field
// A text field has a title, a description and a value.
// It can be changed at any time during the actor's turn, and after the actor's time.
function TextField(title, description, startValue) {
	this.inheritFrom = UniqueId;
	this.inheritFrom();

	this.title = title;
	this.description = description;
	this.value = startValue;

} 

// Text Field - Public Methods

// Define public methods 
TextField.prototype.debugDisplay = function() {
	alert( 'TextField[' + this.id + ']: ' + this.title + '(' + this.description + ') = ' + this.value );
}

TextField.prototype.html = function() {
	return_div = $( 
		'<div class="TextField" title="' + this.description + '">' +
		'<span class="title">' + this.title + '</span>' +
		'<span class="value">' + this.value + '</span>' +
		'</div>'
	);
	return return_div;
}

// *********************
// Immutable Text Field - Constructor
// e.g. Name, Origin, etc.
// TODO

// *********************
// Numeric Field - Constructor
// e.g. HP

// A numeric field has a title, description, current value, minumum and maximum.
// The minimum and maximum values are not enforced.
// They are used purely for display purposes.
//   e.g. 	In the case of HP in DND: The minimum is 0, and the maximum is the player's maximum health.
// 		In special cases, the player's health can be buffed above the player's normal maximum.  
//		Similarly the player can have a health below 0. 
// The min and max is not enforced, so as to allow for these kind of special cases. 
// If the current value of this field is below min, or above max, then the display properties of the field
// will be changed to draw attention the field.
// A numeric field can be changed at any time during the actor's turn, and after the actor's time.
function NumericField(title, description, startValue, min, max) {
	this.inheritFrom = UniqueId;
	this.inheritFrom();

	this.title = title;
	this.description = description;
	this.value = startValue;
	this.min = min;
	this.max = max;
} 

// Numeric Field - Public Methods

// Define public methods 
// Display the fields properties via a debug alert
NumericField.prototype.debugDisplay = function() {
	alert( 'NumericField[' + this.id + ']: ' + this.title + '(' + this.description + ') = ' 
	+ this.value + ', (min=' + this.min + ', max=' + this.max + ')');
}

// Increment numeric field (helper method)
NumericField.prototype.increment = function() {
	this.value += 1;
}
// Decremend numeric field (helper method)
NumericField.prototype.decrement = function() {
	this.value -= 1;
}

NumericField.prototype.html = function() {
	return_div = $( 
		'<div class="NumericField" title="' + this.description + '">' +
		'<span class="title">' + this.title + '</span>' +
		'<span class="value">' + this.value + '</span>' +
		'</div>'
	);
	return return_div;
}

// Note:
// The following code is for testing purposes only
// TODO: Remove the following code.
/*
$(document).ready(function() {
		alert( 'DND Example: ' );
		var a = new NumericField('HP', 'Hit Points', 0, 0, 20);
		var b = new TextField('Mood', 'How the actor is feeling', 'shaken');
		a.debugDisplay();
		b.debugDisplay();
		a.increment();
		a.debugDisplay();
		a.increment();
		a.debugDisplay();
		a.decrement();
		a.decrement();
		a.debugDisplay();
	}
);
*/
