# ExCiProxy

cncf.ci CI Proxy provides uniform access to projects's build status for any CI system it has support for through it's plugin system.

## Setup

Use setup.sh to select erlang and elixir versions


## Quick start

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


## testing

# Docker

### Build deps for ex_ci_proxy 

```
	 docker build -t crosscloudci/ciproxy-deps:latest --file Dockerfile.deps .
```

### Build ex_ci_proxy
```
	docker build -t crosscloudci/ciproxy:latest . 
```
	 
### Optional: Push to dockerhub repository
```
	 docker push crosscloudci/ciproxy-deps:latest
```
	
### Optional: push of ex_ci_proxy docker image
```
	 docker push crosscloudci/ciproxy:latest
```

### Test the docker image
```
   docker run -ti crosscloudci/ciproxy:latest
```
### Test with port mapping 
```
	 docker run -e PROJECT_SEGMENT_ENV="master" -e GLOBAL_CONFIG_YML="https://raw.githubusercontent.com/CrossCloudCI/cncf-configuration/master/cross-cloud.yml" -ti crosscloudci/ciproxy:latest -p 4001:4001
```
### Get name of the container 
```
	 docker ps 
```
### Optional: Bash prompt 
```
	docker exec -ti <name of container> /bin/bash 
```
### Get docker ip address 
```
	docker exec -ti <name of container> ip a
```
### Test with docker container ip 
```
	curl -X GET "http://<docker ip address>:port/ci_status_build/commit_ref?project=<ci project>&ref=<commit hash>&arch=AMD64" 
```

# Plugin Development and Standard API
https://github.com/crosscloudci/ex_ci_proxy/blob/master/PLUGIN-DEVELOPMENT.md
 

