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

HelloPharo is developed and tested against virtual machines in Azure.

### Quick

In a nutshell:

* Create an Azure Ubuntu VM
* Log to it using the username/password given in the administration panel
* Create a user with which you want to deploy (e.g., `deploy`)
* Make this user sudoable (so you can install packages)
* Add your SSH public key in `~/.ssh/authorized_keys` on the server for the deploy user.
* Edit the `hosts.ini` and `vars.yml` file in the ansible directory to match your setup
* Launch automated server setup with: `$ ansible-playbook -i ansible/hosts.ini ansible/server-setup.yml`
* Deploy your app with: `$ ./app deploy`
* Use [DeployUtils](http://smalltalkhub.com/#!/~TaMere/DeployUtils) to handle environment within your image (set the `pharo_env` variable in hosts definitions)

See the Troubleshooting section for more information if you run into troubles.

### Details

`$ ansible-playbook -i ansible/hosts.ini ansible/server-setup.yml` will install git, unzip, nginx, pharo and
download the base Pharo3 images. It will also create an nginx configuration file for your project (see `ansible/templates/nginx-site.conf` for details).

Everytime you want to deploy the master branch of your app, run

	$ ./app deploy

## Troubleshooting

* If the git repo containing your code is private, don't forget to generate a
  pair of SSH keys on the server and add the public key as a deployment key in
  the interface of your git repository provider.
* Try to install/start the app on your local machine before even trying on the
  remote server.
* If you're using a cloud service provider (e.g., AWS, Azure, Google), don't forget to
  open the port 80 in the administration interface.
* Be sure that the port on which you start the application (in `start.st`) is the
  same you defined in `port` variable in `vars.yml`


## Assets

The nginx configuration will directly serve the files located in `public/` folder.

## Known limitations

There's little chance that we overcome the following limitations:

- Suitable for single image application (no load balancing)
- Use git for versionning (even though your Smalltalk code can be hosted in
  a monticello repository)
- Only runs on Ubuntu Linux (using the Pharo PPA)

## To Do

- Provide a default preference file (to have, at least, a common package-cache
  for all the images)
- symbolic link to `system` directory. It will contain assets generated by the app
  (e.g., the pictures uploaded by the users)
- Implement rollback
- Separate deploy user with the server-setup user. The deploy user does not need
  sudo root.
