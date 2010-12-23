
// *********************
// Actor - Constructor

// An actor represents an rpg charactor.
// An actor has many fields.
// The actor will exist in a campaign
// An actor must be able to exist within an 'initiative order' (or similar actor queue)
function Actor(fields) { 
	this.fields = fields;
}

Actor.prototype.html = function() {
	var actorDiv = $('<div class="Actor"></div>')
	for ( var fieldIndex in this.fields ){
		actorDiv.append( $( this.fields[fieldIndex].html() ) );
		this.fields[fieldIndex].debugDisplay();	
	}
	return actorDiv;
}

Actor.prototype.draw = function() {
	$('body').append( this.html() );
}


function Barbarian(name) {
	var fields = new Array();
	fields.push( new TextField('Name', "Name", name) );
	fields.push( new NumericField('HP', "Hit Points", 20, 0, 20) );
	this.actor = new Actor(fields);
}

$(document).ready(function() {
		var bob_the_barbarian = new Barbarian('bob');
		var bruce_the_barbarian = new Barbarian('bruce');
		bob_the_barbarian.actor.draw();
	}
);
