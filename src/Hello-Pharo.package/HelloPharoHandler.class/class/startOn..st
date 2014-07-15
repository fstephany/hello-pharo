public
startOn: portNumber
	self stop.
	server := ZnServer defaultServerClass startOn: portNumber.
	server delegate: self current.
	^server.