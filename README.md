# Scala Development Container

![](https://images.microbadger.com/badges/image/vidbina/scala-dev-env.svg) ![](https://images.microbadger.com/badges/version/vidbina/scala-dev-env.svg)

Used this container to run through the [Functional Programming Principles in
Scala](https://www.coursera.org/learn/progfun1/home/welcome) course by
[Martin Odersky](https://github.com/odersky).

If you are unfamiliar with docker the [documentation provided by
Docker](https://docs.docker.com/engine/getstarted/) may help to get you started.

Assuming that you want to work on a project at the path `$PROJECT_PATH` and
you already have docker installed you may run the container using

```
docker run -it vidbina/scala-dev-env:latest -v $PROJECT_PATH:/src
```

The directory `$PROJECT_PATH` will be mounted in `/src` and the terminal will
drop into an `sbt` session right away. If you don't want to be dropped into
`sbt`, specify the entrypoint of choice. The entrypoint chosen below is
`/bin/bash` which should drop you into a trusty old bash session.

```
docker run -it vidbina/scala-dev-env:latest -v $PROJECT_PATH:/src /bin/bash
```

Since containers are stateless any work done while the container is running
will not be persisted unless
 - the changes are made on a mounted volume, in which case all changes are
 not really happening in the container but directory on the source directory
 in the host filesystem, or 
 - the changes are committed.

Since `sbt` will most likely pull some packages the first time you start sbt
in a new project, you may want to commit the results by opening a new terminal
session while the container is still running and executing

```
docker commit $NAME_OF_HASH_OF_THE_CONTAINER $COMMITED_IMAGE_NAME[:$TAG]
```.

> The scala build tool pulls packages into another directory in the container,
therefore unless you choose to commit the state of the container, you will
probably have to pull all packages again the next time you start the container.
Starting the container anew basically means going back to square one. It's
a good thing you're walking through this course because the concept of
statelessness is something you're going to get quite comfortable with during
the course of this experience :wink:.

Since I use this container to walk through the Scala course by Martin Odersky
I commit my environments by exercise e.g.:
`docker commit $SOME_HASH vidbina/scala-dev-env:ex-2`.
