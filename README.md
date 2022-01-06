# RootlessRouterDocker
This is the docker image for this project

https://github.com/KusakabeSi/RootlessRouter-UML

## How to build it

Prepare build kit
```
# make your computer able to rum arm64 binary
docker run --rm --privileged docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3
# enable expremental feature
export DOCKER_CLI_EXPERIMENTAL=enabled
export DOCKER_BUILDKIT=1
docker buildx create --name mybuilder_az --driver docker-container
docker buildx use mybuilder_az
```

Build in local
```bash
docker buildx build  --platform linux/amd64 -t whojk/dn42docker . --output="type=docker"

#Test in localhost
#-v /home/hujk/Documents/DN42-AutoPeer:/etc/dn42ap_py 
docker run -it --rm --env-file=env_file_any -e NODE_NAME=tw --name=dntw  --network host --cap-add NET_ADMIN  whojk/dn42docker
docker exec -it dntw bash
```

Build and push
```bash
docker buildx build  --platform linux/amd64 -t kskbsi/rootlessrouter . --push
```

## Environment Variables

1. `GIT_REPO_ADDR` : git repo
1. `SSH_KEY` : `0/1`, run `apt upgrade` at startup
1. `NODE_NAME`: node name
