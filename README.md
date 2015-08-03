Bash completion script for VirtualBox
=====================================

This script enables you to autocomplete command-line arguments when using
the `VBoxManage` tool of [VirtualBox](https://www.virtualbox.org/) with
[Bash](http://www.gnu.org/software/bash/).


Install on OS X
---------------

We recommend you install [Homebrew](http://brew.sh/). For a cleaner install,
we also recommend that you install [Homebrew Cask](http://caskroom.io/) and
then install VirtualBox with it, just running `brew cask install virtualbox`.

Once you have Homebrew, install its general Bash completion infrastructure:

	brew install bash-completion

Then, install this script:

	cd $(brew --prefix)/etc/bash_completion.d
	curl -LO https://raw.githubusercontent.com/bgandon/bash-completion-virtualbox/master/vboxmanage_completion.bash

As an alternative, you can install this script from a Git clone,
which can help if you whant to share your improvements to the
world:

	mkdir ~/workspace && cd ~/workspace
	git clone git@github.com:tfmalt/bash-completion-virtualbox.git
	ln -s `pwd`/bash-completion-virtualbox/vboxmanage_completion.bash /usr/local/etc/bash_completion.d/

On OS X, a [Homebrew Formula](https://github.com/Homebrew/homebrew/tree/master/share/doc/homebrew#contributing)
is still to be made.


Install on Linux
----------------

### Pre-requisite
* The bash completion infrastructure. If not installed yet, run `apt-get install bash-completion` or equivalent for RH-based systems, but most OS's have it installed by default

### System-wide configuration (requires root)
1. Copy the file  `vboxmanage_completion.bash` from this repo into `/etc/bash_completion.d/`. This folder contains all the system completions configurations
2. Source the completion file by doing `source /etc/bash_completion.d/vboxmanage_completion.bash`

### User-only configuration (doesn't require root)
1. Add the *content* of `vboxmanage_completion.bash` (except the first line, #!) in this repo into `~/.bash_completion`. 
2. Source the completion file by doing `source ~/.bash_completion`
