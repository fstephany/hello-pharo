
FileStream stdout cr; nextPutAll: 'Installing Hello-Pharo'.

gitRepository := MCFileTreeRepository new directory: (FileLocator imageDirectory / 'src').

Gofer it
  repository: gitRepository;
  package: 'Hello-Pharo'.
  load.

FileStream stdout cr; nextPutAll: 'Done.'.

Smalltalk snapshot: true andQuit: true.
