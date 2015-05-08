# Installation instructions

## Pre-requisite
* The bash completion infrastructure. If not installed yet, run `apt-get install bash-completion` or equivalent for RH-based systems, but most OS's have it installed by default

## System-wide configuration (requires root)
1. Copy the file  `vboxmanage_completion.bash` from this repo into `/etc/bash_completion.d/`. This folder contains all the system completions configurations
2. Source the completion file by doing `source /etc/bash_completion.d/vboxmanage_completion.bash`

## User-only configuration (doesn't require root)
1. Add the *content* of `vboxmanage_completion.bash` (except the first line, #!) in this repo into `~/.bash_completion`. 
2. Source the completion file by doing `source ~/.bash_completion`
