#_RedCar Sparkup_

###Info
Adds [Sparkup](https://github.com/rstacruz/sparkup/tree/) capabilities to the Redcar text editor

###Install
	cd ~/.redcar/plugins
	git clone git@github.com:pockata/redcar-sparkup.git sparkup
	cd sparkup
	git submodule init
	git submodule update

###Note
For now, Sparkup requires Python to run. It's preinstalled on OS X and most Linux distros.
On Windows, you can install it from [here](http://www.python.org/download/windows/)


###Todo
- Rewrite Sparkup to remove Python as a requirement
- Add [Zen Coding](http://code.google.com/p/zen-coding/) as an optional parser