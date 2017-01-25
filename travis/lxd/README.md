#Travis-CI LXD integration [![Build Status](https://travis-ci.org/elventear/travis-lxd-test.svg?branch=master)](https://travis-ci.org/elventear/travis-lxd-test)

This repo provides a recipe to leverage LXD containers on top of Travis-CI, for test automation based on the OS of choice.

The important steps to provision an LXD container that is SSH accessible from the Host is are detailed in `before_install.sh`. `script.sh` provides a sample test, which just performs some action on the LXD container via SSH.

##Local Testing and Development

I have tried to provide an enviroment for testing the development scripts locally using vagrant. To fire up execute the following:

```shell
> cd dev
> vagrant up
```