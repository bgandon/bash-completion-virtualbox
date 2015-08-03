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

You first need the bash completion infrastructure. Most Linux distributions
have it installed by default. If not, then install it:

* Run `apt-get install bash-completion` on Debian-based distributions
* Run `yum --enablerepo=epel install bash-completion.noarch` on CentOS, or
  equivalent for other RedHat-based distributions.


### System-wide configuration (requires root)

Copy the file  `vboxmanage_completion.bash` from this repo into `/etc/bash_completion.d/`.
This folder contains the system completions configurations that will be run by
the new shells you'll open later.

	cd /etc/bash_completion.d
	sudo curl -LO https://raw.githubusercontent.com/bgandon/bash-completion-virtualbox/master/vboxmanage_completion.bash

For the completion to work in your current shell, source the completion file
with

	source /etc/bash_completion.d/vboxmanage_completion.bash


### User-only configuration (doesn't require root)

Add the *content* of `vboxmanage_completion.bash` in `~/.bash_completion`,
except the first she-bang line (the one that starts with `#!`).

For the completion to work in your current shell, source the completion file
with

	source ~/.bash_completion


Authors and License
-------------------

Copyright (c) 2012, [Thomas Malt](https://github.com/tfmalt)
Copyright (c) 2015, [Benjamin Gandon](https://github.com/bgandon)
All rights reserved.

Code is under the [BSD 2 Clause (NetBSD) license](LICENSE.txt).
