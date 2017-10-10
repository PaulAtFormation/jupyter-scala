Docker image for running Jupyter Notebooks for Scala

***Features:***
  
  * Completely dockerized environment
  * Extends Jupyter docker image jupyter/minimal-notebook:281505737f8a
  * Adds Oracle JDK version 8 
  * Adds SBT 0.13.x
  * Adds [Jupyter Scala](https://github.com/jupyter-scala/jupyter-scala) kernels for Scala versions 2.11 and 2.12
  	
For details regarding Jupyter docker image, visit [jupyter/minimal-notebook docker repo](https://hub.docker.com/r/jupyter/minimal-notebook/). 
For details regarding Jupyter-Scala, visit the Github project page of [Jupyter Scala](https://github.com/jupyter-scala/jupyter-scala).

### Pull docker image

To pull the latest version of the image:

```
docker pull anskarl/jupyter-scala:latest
```

If you like to pull a specific version, e.g., version 1.0.1:
```
docker pull anskarl/jupyter-scala:1.0.1
```

### Start docker image

To start this docker image you can simply execute a `docker run` command that points to the `anskarl/jupyter-scala:${IMAGE_VERSION}`, where `${IMAGE_VERSION}` is the version of this project (e.g., 1.0.0). 


For simplicity you can run the following utility script:

```
./jupyter-scala.sh
```

This utility script creates an instance of `anskarl/jupyter-scala:${IMAGE_VERSION}` and binds the current working path inside the running container into `/home/${NB_USER}/work`, where `${NB_USER}` is the unprivileged user of jupyter (default is `joyvan`, see [details](https://github.com/jupyter/docker-stacks/tree/master/minimal-notebook#what-it-gives-you)). Furthermore, since [Jupyter Scala](https://github.com/jupyter-scala/jupyter-scala) uses [Coursier](http://get-coursier.io) for artifact fetching, this script uses a docker volume to store all downloaded dependencies (named as `jupyter_scala_coursier`). The volume is automatically created if does not exists.



### Build image locally

In order to build docker image locally, you can execute the following:

```
./build.sh
```
After a successful build the resulting image is `anskarl/jupyter-scala:${IMAGE_VERSION}`, where `${IMAGE_VERSION}` is the version of this project (e.g., 1.0.1)
