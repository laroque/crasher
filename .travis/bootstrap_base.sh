#!/bin/bash

## conventional notes
## - true comments that are not in-line start with double ## (commented out lines are single)
## - local variables are lower_snake_case (leaves UPPER_SNAKE for environment stuff)
## - echo statements that are just progress notes start with "-- "


usage() {
    echo -e "Usage: $0 \n"\
         "    -u (user portion of image specification)\n"\
         "    -r (repo portion of image specification)\n"\
         "    -t (tag portion of image specification)\n" \
         "    -a (desired architecture, one of [arm7, amd64])"
    exit 2
}

echo "-- parsing bootstrap base image options"

if [[ $1 == "" ]]; then
  usage
fi
while getopts u:r:t:a: option ; do
  case $option in
    u) # store user
      if [[ $OPTARG == "" ]]; then
        echo "user flag requires value"
        exit 2
      fi
      image_user="$OPTARG"
      ;;
    r) # store repo
      if [[ $OPTARG == "" ]]; then
        echo "repo flag requires value"
        exit 2
      fi
      image_repo="$OPTARG"
      ;;
    t) # store tag
      if [[ $OPTARG == "" ]]; then
        echo "tag flag requires value"
        exit 2
      fi
      image_tag="$OPTARG"
      ;;
    a) # store target architecture
      if [[ $OPTARG == "" ]]; then
        echo "architecture flag requires value"
        exit 2
      fi
      if [[ "amd64 arm7" =~ (^|[[:space:]])"$OPTARG"($|[[:space:]]) ]]; then
        target_arch="$OPTARG"
      else
        echo "arch '${OPTARG}' not recognized"
        usage
      fi
      ;;
    *) # print usage
      usage
      ;;
  esac
done
if [[ -z $image_user || -z $image_repo || -z $image_tag || -z $target_arch ]]; then
    echo "all arguments are required"
    usage
fi

original_qemu_path=""
case $target_arch in
    amd64)
        original_qemu_path="/usr/bin/qemu-x86_64-static"
        echo "-- set qemu vars for amd64"
        ;;
    arm7)
        original_qemu_path="/usr/bin/qemu-arm-static"
        echo "-- set qemu vars for arm7"
        ;;
esac

echo "-- should build from $image_user/$image_repo:$image_tag -> local/emulation_base:latest"

dot_travis_path=`dirname $0`
dot_travis_path=`readlink -e $dot_travis_path`

# bootstrap a custom base image with emulation
set -x
cp $original_qemu_path ${dot_travis_path}/this_qemu
sed 's#QEMU_TARGET_LOCATION#${original_qemu_path}#' $dot_travis_path/Dockerfile.shim > $dot_travis_path/Dockerfile
docker build \
    --build-arg image_user=$image_user \
    --build-arg image_repo=$image_repo \
    --build-arg image_tag=$image_tag \
    -t local/emulation_base:latest \
    -f $dot_travis_path/Dockerfile \
    $dot_travis_path
set +x

#
