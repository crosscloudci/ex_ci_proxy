# Plugin Development and Standard API
## plugin build executable
```
./ci_plugin/<plugin name>/bin/build-deps
./ci_plugin/<plugin name>/bin/build
```
## Status executable and response format
1. The output is **tab delimited**
1. The **first line** is a **header**
1. The **second line** is data 

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
 **Name** is the name of the plugin
 
 **Interface** type of plugin
 
 **Repo** is the github location of the plugin
 
 **Ref** is the branch or tag of the plugin 

 
