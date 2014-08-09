" Start all the long running tasks here.
"

FileStream stdout cr; nextPutAll: 'Launching Hello-Pharo'; cr.

HelloPharoHandler startOn: 8081.
