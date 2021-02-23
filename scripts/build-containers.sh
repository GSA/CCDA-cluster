SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPT_NAME='build-container'
nl=$'\n'
SCRIPT_DES="This script will stop and remove any Docker containers currently \
running on your machine,${nl}   clear the Docker cache, configure the frontend \
application's HTTP context for containers,${nl}   build the application \
images, delete any dangling images leftover after the build${nl}   completes and \
then orchestrate the application the application images through docker-compose."
source "$SCRIPT_DIR/util/logging.sh"


if [ "$1" == "--help" ] || [ "$1" == "--h" ] || [ "$1" == "-help" ] || [ "$1" == "-h" ]
then
    help_print "$SCRIPT_DES" $SCRIPT_NAME
else
    ROOT_DIR=$SCRIPT_DIR/..
    APP_DIR=$ROOT_DIR/CCDA
    WEB_DIR=$ROOT_DIR/CCDA-web
    CONF_DIR=$WEB_DIR/conf
  
    log 'Initializing container environment' $SCRIPT_NAME
    source $SCRIPT_DIR/util/env-vars.sh container

    log "Configuring \e[3m$WEB_CONTAINER_NAME\e[0m With Upstream Server at \e[3m$CCDA_HOST:$CCDA_PORT\e[0m" $SCRIPT_NAME
    cp $CONF_DIR/nginx.ccda.conf $CONF_DIR/nginx.conf

    log '>> Removing running containers' $SCRIPT_NAME
    docker-compose down

    log '>> Clearing Docker cache' $SCRIPT_NAME
    docker system prune -f

    for arg in "$@"
    do 
        if [ "$arg" == "--fresh" ] || [ "$arg" == "-f" ]
        then
            log "Scrubbing application of artifacts from previous Builds" $SCRIPT_NAME
            # TODO
        fi
    done

    log "Building application image \e[3m$APP_IMG_NAME:$APP_TAG_NAME" $SCRIPT_NAME
    docker build -t $APP_IMG_NAME:$APP_TAG_NAME $APP_DIR

    log "Building web image \e[3m$WEB_IMG_NAME:$WEB_IMG_NAME" $SCRIPT_NAME
    docker build -t $WEB_IMG_NAME:$WEB_IMG_TAG $WEB_DIR

    DANGLERS=$(docker images --filter "dangling=true" -q)
    if [ "$DANGLERS" != "" ]
    then 
        log 'Deleting dangling images' $SCRIPT_NAME
        docker rmi -f $DANGLERS
    fi
    
    log "Configuring \e[3mdocker-compose.template.yml\e[0m with environment variables" $SCRIPT_NAME
    SUB_STR='$NGINX_PORT,$CCDA_HOST,$CCDA_PORT,$POSTGRES_PORT,$MYSQL_PORT,$APP_IMG_NAME,$APP_IMG_TAG,$WEB_IMG_TAG,$WEB_IMG_NAME'
    envsubst $SUB_STR < $ROOT_DIR/docker-compose.template.yml | sponge $ROOT_DIR/docker-compose.yml

    log "Images built. Run \e[3mdocker-compose up\e[0m to launch \e[7mCCDA\e[0m" $SCRIPT_NAME
fi 