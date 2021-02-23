# CCDA Application Cluster

This repo orchestrates the containers residing in the [CCDA](https://github.com/GSA/CCDA) and [CCDA-web](https://github.com/GSA/CCDA-web) repositories. Both repos are included as submodules, so when you clone this repo be sure to clone it in the following way,

> git clone --recurse-submodules https://github.com/GSA/CCDA-cluster

# Quickstart

Copy the <i>/env/.sample.env</i> file into a new file named <i>/env/container.env</i>,

> cp /env/.sample.env /env/container.env

Adjust the environment variables to your liking. <b>APP_ENV</b>, <b>SECRET_KEY</b> and all credential environment variables will need changed. See comments in <i>/env/.sample.env</i> for more information about the purpose of each variable. Execute the following script,

> ./scripts/build-containers.sh && docker-compose up

To bring the application cluster up.
