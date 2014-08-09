" Change the content of this file with the code to load your application.
  Keep the last line, you don't want to keep the image running, that will be the
  job of start.st
"
| gitRepository |

FileStream stdout cr; nextPutAll: 'Installing Hello-Pharo'; cr.

gitRepository := MCFileTreeRepository new directory: (FileLocator imageDirectory / 'src').

Gofer it
  repository: gitRepository;
  package: 'Hello-Pharo';
  load.

FileStream stdout cr; nextPutAll: 'Done.'; cr.

Smalltalk snapshot: true andQuit: true.
