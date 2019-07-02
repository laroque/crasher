#!/bin/bash

usage() {
    echo -e "Usage: $0 \n"\
         "    -u (user portion of image specification)\n"\
         "    -r (repo portion of image specification)\n"\
         "    -t (tag portion of image specification)"
    exit 2
}

echo "parsing bootstrap base image options"

if [[ $1 == "" ]]; then
  usage
fi
while getopts u:r:t: option ; do
  case $option in
    u) # store user
      if [[ $OPTARG == "" ]]; then
        echo "user flag requires value"
        exit 2
      fi
      IMAGE_USER="$OPTARG"
      ;;
    r) # store repo
      if [[ $OPTARG == "" ]]; then
        echo "repo flag requires value"
        exit 2
      fi
      IMAGE_REPO="$OPTARG"
      ;;
    t) # store tag
      if [[ $OPTARG == "" ]]; then
        echo "tag flag requires value"
        exit 2
      fi
      IMAGE_TAG="$OPTARG"
      ;;
    *) # print usage
      usage
      ;;
  esac
done
if [[ -z $IMAGE_USER || -z $IMAGE_REPO || -z $IMAGE_TAG ]]; then
    echo "all arguments are required"
    usage
fi

echo "should build $IMAGE_USER/$IMAGE_REPO:$IMAGE_TAG"

dot_travis_path=`dirname $0`
dot_travis_path=`readlink -e $dot_travis_path`

docker build \
    --build-arg IMAGE_USER=$IMAGE_USER \
    --build-arg IMAGE_REPO=$IMAGE_REPO \
    --build-arg IMAGE_TAG=$IMAGE_TAG \
    -t emulation_base:local
    $dot_travis_path
