#!/bin/bash
cd "$(dirname "$0")" || exit 1
if [ ! -r ./bash_unit ] ; then
    # https://github.com/pgrange/bash_unit.git
    bash <(curl -s https://raw.githubusercontent.com/pgrange/bash_unit/master/install.sh)
fi

./bash_unit "$@" tests/test_*.sh
