SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
nl=$'\n'
ind="  "
tab="     "
SCRIPT_DES="This script will activate the environment variables found in the \e[3m.env\e[0m ${nl}\
${ind}file specifed as an argument. Source this script through bash, e.g. ${nl}${nl}${tab}\e[2msource \
./env-var.sh container\e[0m${nl}${nl}${ind}This will load the environment variables in \
\e[3mcontainer.env\e[0m file into your${nl}${ind}current shell session."
source "$SCRIPT_DIR/logging.sh"

if [ "$1" == "--help" ] || [ "$1" == "--h" ] || [ "$1" == "-help" ] || [ "$1" == "-h" ]
then
    help_print "$SCRIPT_DES" "env-vars"
else
    if [ -f "$SCRIPT_DIR/../../env/local.env" ]
    then
        set -o allexport
        source $SCRIPT_DIR/../../env/$1.env
        set +o allexport
    else
        cp $SCRIPT_DIR/../../env/.sample.env $SCRIPT_DIR/../../env/$1.env
        log "Please Configure \e[4m$1.env\e[0m File And Reinvoke Script." "env-vars"
    fi
fi
