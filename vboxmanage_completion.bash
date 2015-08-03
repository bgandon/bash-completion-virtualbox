#!/usr/bin/env bash
#
# Attempt at autocompletion script for vboxmanage. This scripts assumes an
# alias between VBoxManage and vboxmanaage.
#
# Copyright (c) 2012  Thomas Malt <thomas@malt.no>
#

alias vboxmanage="VBoxManage"

complete -F _vboxmanage vboxmanage

# export VBOXMANAGE_NIC_TYPES

_vboxmanage() {
    local cur prev opts

    COMPREPLY=()

    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # echo "cur: |$cur|"
    # echo "prev: |$prev|"

    case $prev in
        -v|--version)
            return 0
            ;;
        -l|--long)
            opts=$(__vboxmanage_list "long")
            COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
            return 0
            ;;
        --nic[1-8])
            # This is part of modifyvm subcommand
            opts=$(__vboxmanage_nic_types)
            COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
            ;;
        startvm)
            opts=$(__vboxmanage_list-stopped-vms)
            COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
            return 0
            ;;
        list)
            opts=$(__vboxmanage_$prev)
            COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
            return 0
            ;;
        --type)
            COMPREPLY=($(compgen -W "gui headless" -- ${cur}))
            return 0
            ;;
        gui|headless)
            # Done. no more completion possible
            return 0
            ;;
        vboxmanage)
            # In case current is complete command we return emmideatly.
            case $cur in
                startvm|list|controlvm|showvminfo|modifyvm)
                    COMPREPLY=($(compgen -W "$cur "))
                    return 0
                    ;;
            esac
            # echo "Got vboxmanage"
            # opts=$(__vboxmanage_default)
            # Note: the default sed in OS X only supports \{1,\} and not \+
            opts="$(__vboxmanage_default)"
            COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
            return 0
            ;;
        -q|--nologo)
            opts=$(__vboxmanage_default)
            COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
            return 0
            ;;
        controlvm|showvminfo|modifyvm)
            opts=$(__vboxmanage_list-all-vms)
            COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
            return 0
            ;;
        vrde|setlinkstate*)
            # vrde is a complete subcommand of controlvm
            opts="on off"
            COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
            return 0
            ;;
    esac

    if echo " $(__vboxmanage_list-all-vms) " | grep -Fq " $prev "; then
        pprev=${COMP_WORDS[COMP_CWORD-2]}
        # echo "previous: $pprev"
        case $pprev in
            startvm)
                opts="--type"
                COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
                return 0
                ;;
            controlvm)
                opts=$(__vboxmanage_controlvm $VM)
                COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
                return 0;
                ;;
            showvminfo)
                opts="--details --machinereadable --log"
                COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
                return 0;
                ;;
            modifyvm)
                opts=$(__vboxmanage_modifyvm)
                COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
                return 0
                ;;
        esac
    else
        echo "'$prev' not in '$(__vboxmanage_list-all-vms)'"
    fi

    # echo "Got to end withoug completion"
}

__vboxmanage_nic_types() {
    vboxmanage \
        | grep -F ' nic<' \
        | sed -e 's/.*nic<1-N> \([a-z\|]*\).*/\1/' \
        | tr '|' ' '
}

function __vboxmanage_extract-vm-names {
    cut -d' ' -f1 | tr -d '"'
}

function __vboxmanage_list-all-vms {
    if [ -z "$1" ]; then
        SEPARATOR=" "
    else
        SEPARATOR=$1
    fi

    VMS=
    for VM in $(vboxmanage list vms | __vboxmanage_extract-vm-names); do
        [ -n "$VMS" ] && VMS="${VMS}${SEPARATOR}"
        VMS="${VMS}${VM}"
    done

    echo $VMS
}

function __vboxmanage_list-running-vms {
    if [ "$1" == "" ]; then
        SEPARATOR=" "
    else
        SEPARATOR=$1
    fi

    VMS=""
    for VM in $(vboxmanage list runningvms | cut -d' ' -f1 | tr -d '"'); do
        [ -n "$VMS" ] && VMS="${VMS}${SEPARATOR}"
        VMS="${VMS}${VM}"
    done

    echo $VMS
}

function __vboxmanage_list-stopped-vms {
    RUNNING=$(__vboxmanage_list-all-vms)

    STOPPED=""
    for VM in $(__vboxmanage_list-running-vms); do
        # Note: here we add spaces before and after both text and pattern
        #       in order to produce matches only on complete VM names
        if echo " $RUNNING " | grep -Fqv " $VM "; then
            STOPPED="$STOPPED $VM"
        fi
    done
    echo $STOPPED
}

__vboxmanage_list() {
    INPUT=$(vboxmanage list | tr -s '\n[]|' ' ' | cut -d' ' -f4-)

    PRUNED=""
    if [ "$1" == "long" ]; then
        for WORD in $INPUT; do
            [ "$WORD" == "-l" ] && continue;
            [ "$WORD" == "--long" ] && continue;

            PRUNED="$PRUNED $WORD"
        done
    else
        PRUNED=$INPUT
    fi

    echo $PRUNED
}

__vboxmanage_controlvm() {
    local VM="$1"
    options=$( \
        vboxmanage controlvm \
            | grep '^                            [a-z]' \
            | sed -e 's/^ *\([a-z<1N>|-]\{1,\}\).*/\1/; s/\|$//' \
            | tr -d ' ' \
            | tr '|' '\n' \
    )
    NIC_OR_NAT_OPTS_PATTERN='^(setlinkstate|(nic|nat)[a-z]*)<1-N>'
    nic_opts="setlinkstate $(echo "$options" | grep -E "$NIC_OR_NAT_OPTS_PATTERN" | sed -e 's/<1-N>//')"
    options=$(echo "$options" | grep -Ev "$NIC_OR_NAT_OPTS_PATTERN")

    # setlinkstate<1-N> nic<1-N> nictrace<1-N> nictracefile<1-N> nicproperty<1-N> nicpromisc<1-N> natpf<1-N> natpf<1-N>
    nic_cmds=
    for num in $(__vboxmanage_list-active-nics-nums "$VM"); do
        for nic_opt in $nic_opts; do
            nic_cmds="$nic_cmds $nic_opt$num"
        done
    done

    echo $options $nic_cmds | tr ' ' '\n' | sort | uniq
}

__vboxmanage_modifyvm() {
    options=$( \
        vboxmanage modifyvm \
            | grep -F '[--' \
            | grep -Fv '[--nic<' \
            | sed 's/ *\[--\([a-z-]*\).*/--\1/' \
            | sort \
    )
    # Exceptions
    for i in {1..8}; do
        options="$options --nic${i}"
    done
    echo $options
}

function __vboxmanage_list-active-nics-nums {
    local VM="$1"
    vboxmanage showvminfo "$VM" --machinereadable \
        | awk '/^nic[1-8]=/ && ! /="none"$/' \
        | cut -d= -f1 \
        | sed -e 's/^nic//'
}

__vboxmanage_default() {
    options=$(vboxmanage | sed -n -e 's/^ \{2\}\[\([a-z|-]\{1,\}\).*$/\1/p' | tr '|' ' ')
    commands=$(vboxmanage | sed -n -e 's/^ \{2\}\([a-z-]\{1,\}\).*$/\1/p' | uniq)
    echo $options $commands
}
