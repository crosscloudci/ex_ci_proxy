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
	 docker run -e PROJECT_SEGMENT_ENV="master" -e GITLAB_CI_YML="https://raw.githubusercontent.com/CrossCloudCI/cncf-configuration/master/cross-cloud.yml" -ti crosscloudci/ciproxy:latest -p 4001:4001 
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

# Plugin Development
## plugin build executable
```
./ci_plugin/<plugin name>/bin/build-deps
./ci_plugin/<plugin name>/bin/build
```
## Status executable and response format
### The first line is a header
### The second line is tab delimited, 
```
./ci_plugins/<plugin name>/bin/status status --project <orgname>/<projectname> --commit <commit name> 
status  build_url
success https://travis-ci.org/crosscloudci/testproj/builds/572521581 
```
Status MUST be running, success, or failed
build_url MUST be a valid url to the ci system's build url

## ci_plugin.yml configuration
```
plugins: 
  - name: "travis-ci" 
    interface: "cli" 
    repo: "http://github.com/crosscloudci/ci_plugin_travis_go"
    ref: "master"
```
 Name is the name of the plugin
 Interface type of plugin
 Repo is the github location of the plugin
 Ref is the branch or tag of the plugin 

 

