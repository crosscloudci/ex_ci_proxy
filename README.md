# ExCiProxy

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


## setup

Use setup.sh to select erlang and elixir versions

## testing

## Docker

### Build ex_ci_proxy
```
	docker build -t crosscloud/ciproxy:latest . 
```
	
### Build deps for ex_ci_proxy 

```
	 docker build -t crosscloudci/ciproxy-deps:latest --file Dockerfile.deps 
```
	 
### Optional: Push to dockerhub repository
```
	 docker push crosscloudci/ciproxy-deps:latest
```
	
### Optional: push of ex_ci_proxy docker image
```
	 docker push crosscloud/ciproxy:latest
```

### Test the docker image
```
   docker run -ti ciproxy:latest
```
### Test with port mapping 
```
	 docker run -ti ciproxy:latest -p 4001:4001    
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
	docker exec -ti <name of container> ifconfig
```
### Test with docker container ip 
```
	curl -X GET "http://localhost:<docker ip address>/ci_status_build/commit_ref?project=<ci project>&ref=<commit hash>&arch=AMD64" 
```
