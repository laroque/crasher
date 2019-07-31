This directory is a sandbox for testing the travs boilerplate needed to get automation of multi-architecture builds with qemu on travis-ci.

## Add this to another repo
Making notes while deploying this system to another repo:

 1. This directory (.travis in the laroque/crasher repo) should be copied into the target repo.
    If a directory with the same name already exists, either merge the contents or you can rename this one and update the paths described in the `.travs.yml` file (the contained scripts should all we able to cope with being moved).
 2. Review the `.travs.yml` file from this repository and merger with any existing travis file if it already exists.

## Notes/gotchas/assumptions

### Registry authentication

This example assumes that you are publishing the resuling images to docker hub's image registry, and will start by attempting to
execute `docker login` based on two environment variables (`DOCKER_PASSWORD` and `DOCKER_USERNAME`).
These should be securely configured in travis (see [the official docs](https://docs.travis-ci.com/user/environment-variables/#defining-variables-in-repository-settings)).

### Base images

The `bootstrap_image.sh` needs to be passed arguments (-u -r and -t) which point it to an image for the desired architecture.
For "official" images (eg `_/debian:9`) from dockerhub, you need to point to the underlying image, not a manifest (eg `amd64/debian:9`).
The bootstrap script will then build a local image with the required qemu executable and pass that *local* image to the build for your project's image (see notes about the Dockerfile).

### Dockerfile conventions

In order for architecture emulation to work as expected and a project to maintain a single Dockerfile, there are some extra notes:

1. Any build stage which includes a `RUN` directive must use `FROM ${img_user}/${img_repo}:${img_tag}` (these `--build-arg` values are passed in the bootstrap script).
2. If the build is in a single stage, the image produced will include the qemu executable, as well as the layers for the produced base image used for emulation (this may be fine, depending on the use case).
3. An image build stage which does not include any `RUN` directives may use a different base image (it will need to be compatible with x86_64 while building on travis.
4. If you want to minimize the image size and/or keep the qemu executable out, use a multi-stage build in your Dockerfile. The final stage can be `FROM` whatever base image you would normally use and copy the build artifacts from earlier stages (which are compatible with the emulated architecture). **NOTE:** this hasn't been tested here and the bootstrap script will need to be modified to pass both the local base image and the true (architecture-specific) base image to the Dockerfile.
