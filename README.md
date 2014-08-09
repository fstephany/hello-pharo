# HelloPharo

## Goal of the project

HelloPharo is a small code farm that creates a basic project architecture
for easy deployment.

This code farm is a starting point. We expect you to tweak the configuration to
fit your need, we just provide sensible default.

A developer should not have to think too much about the deployment and configuration
details when he starts to develop a service on the web with pharo.

One of the secret goal of HelloPharo is to provide a stack of tools to implement a
[Twelve-factor app](http://12factor.net/).

## Usage

### Server setup

HelloPharo is developed and tested against virtual machines in Azure. In a nutshell:

* Create an Azure Ubuntu VM
* Log to it using the username/password given in the administration panel
* Add your SSH public key in `~/.ssh/authorized_keys` on the server
* Edit the variable file in the ansible directory
* Move to the ansible directory and launch server setup: `$ ansible-playbook -i hosts.ini server-setup.yml`

## Assets

The nginx configuration is made to load assets from the `assets/` folder.

## Known limitations

There's little chance that we overcome the following limitations:

- Suitable for single image application (no load balancing)
- Use git for versionning (even though your Smalltalk code can be hosted in
  a monticello repository)
- Only runs on Ubuntu Linux (using the Pharo PPA)

## To Do

- VM path detection for OSX/Linux
- Implement rollback
