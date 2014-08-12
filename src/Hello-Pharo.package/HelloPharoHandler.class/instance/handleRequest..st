public
handleRequest: request
  | environmentString |
  environmentString := OSPlatform current environment
    at: 'PHARO_ENV'
    ifAbsent: 'development'.

	^ZnResponse ok: (ZnStringEntity text: 'Hello from Pharo on Azure ! ', environmentString).
