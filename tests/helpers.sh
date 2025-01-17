#!/bin/bash -e
# Copyright (C) 2022 Simo Sorce <simo@redhat.com>
# SPDX-License-Identifier: Apache-2.0

title()
{
    case "$1" in
    "SECTION")
        shift 1
        echo "########################################"
        echo "## $*"
        echo ""
        ;;
    "ENDSECTION")
        echo ""
        echo "                                      ##"
        echo "########################################"
        echo ""
        ;;
    "PARA")
        shift 1
        echo ""
        echo "## $*"
        ;;
    "LINE")
        shift 1
        echo "$*"
        ;;
    *)
        echo "$*"
        ;;
    esac
}

cleanup_server()
{
    echo "killing $1 server"
    kill -9 -- $2
}

helper_emit=1

ossl()
{
    helper_output=""
    echo "# r "$1 >> ${TMPPDIR}/gdb-commands.txt
    echo openssl $1
    __out=$(eval openssl $1)
    __res=$?
    if [ $2 -eq $helper_emit ]; then
        helper_output="$__out"
    else
        echo "$__out"
    fi
    return $__res
}

gen_unsetvars() {
    grep "^export" ${TMPPDIR}/testvars \
    | sed -e 's/export/unset/' -e 's/=.*$//' \
    >> ${TMPPDIR}/unsetvars
}
