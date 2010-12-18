
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
// A text field has a title, a description and a default value.
// It can be changed at any time during the actor's turn, and after the actor's time.
function TextField(title, description, defaultValue) {
	this.inheritFrom = UniqueId;
	this.inheritFrom();

	this.title = title;
	this.description = description;
	this.value = defaultValue;

} 

// Text Field - Public Methods

// Define public methods 
TextField.prototype.debugDisplay = function() {
	alert( "TextField[" + this.id + "]: " + this.title + '(' + this.description + ') = ' + this.value );
}

// *********************
// Immutable Text Field - Constructor
// e.g. Name, Origin, etc.
// TODO

// *********************
// Incrementing/Decrementing Numeric- Constructor
// e.g. HP
// TODO

// Note:
// The following code is for testing purposes only
// TODO: Remove the following code.
$(document).ready(function() {
		
		alert( "DND Example: " );
		var a = new TextField('HP', 'Hit Points', '0');
		var b = new TextField('Mood', 'How the actor is feeling', '');
		a.debugDisplay();
		b.debugDisplay();
	}
);
