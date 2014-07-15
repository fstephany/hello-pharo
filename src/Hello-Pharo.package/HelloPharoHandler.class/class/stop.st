public
stop
	server isNil ifFalse:  [ server stop ].
	server := nil.
	current := nil.