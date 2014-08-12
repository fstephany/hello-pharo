public
handleRequest: request
	^ZnResponse ok: (ZnStringEntity text: 'Hello from Pharo on Azure !').
