" Start all the long running tasks here.
"

FileStream stdout cr; nextPutAll: 'Installing Hello-Pharo'.

HelloPharoHandler startOn: 8081.
