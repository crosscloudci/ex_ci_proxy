# Plugin Development and Standard API
## plugin build executable
```
./ci_plugin/<plugin name>/bin/build-deps
./ci_plugin/<plugin name>/bin/build
```

## The CLI needs to accept the following args

## Arguments
1.  -p or --project is the project name in the format of orgname/project
1.  -c or --commit is the commit reference
1.  -t or --tag is the tag name

## Status executable and response format
1. The output is **tab delimited**
1. The **first line** is a **header**
1. The **second line** is data 
1. The **status** should be success, failure, or running
1. The **build_url** should be the url where the status was found

```
./ci_plugins/<plugin name>/bin/status status --project <orgname>/<projectname> --commit <commit name> 
status  build_url
success https://travis-ci.org/crosscloudci/testproj/builds/572521581 
```

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

 
