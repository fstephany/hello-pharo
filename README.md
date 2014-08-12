# HelloPharo

HelloPharo is a small code farm that creates a basic project architecture
for easy deployment.

It is inspired by [Capistrano](http://capistranorb.com/) and is built on top of
[Ansible](http://www.ansible.com/home).

This code farm is a starting point. We expect you to tweak the configuration to
fit your need, we just provide sensible default.

A developer should not have to think too much about the deployment and configuration
details when he starts to develop a service on the web with pharo.

We concentrate on the current stable release of Pharo. This means we've hardcoded the
pharo version.

One of the secret goal of HelloPharo is to provide a stack of tools to implement a
[Twelve-factor app](http://12factor.net/).

## Usage

### Quick install

Make sure the app runs on your machine before even trying on the remote server.

#### On your local machine

0. Install ansible if you don't have it yet. If you're on OSX, we recommend using
   [Homebrew](http://brew.sh/). Windows user you're out of luck, Ansible does not
   support Windows (yet), sorry!
1. Download the latest version by clicking `Download ZIP` in github and unzip it.
2. Download the latest pharo 3 image, changes and sources file. We use
  http://files.pharo.org/image/30/30852.zip and http://files.pharo.org/sources/PharoV30.sources.zip
3. Rename the files as `pharo.image` and `pharo.changes` and copy them in the newly
  created `hello-pharo` directory. Copy the `PharoV30.sources` as well.
4. Open a terminal and navigate to the `hello-pharo` directory.
5. Avoid getting some junk in your git repository: `$ cp gitignore.example .gitignore`
6. Edit the `install.st` script to load your code. We usually put our code in
   the `src/` directory but feel free to load anything from anywhere (e.g., Smalltalkhub).
   Do not delete the "save and quit" instruction from the script, it will make your
   server hangs when you deploy.
7. Edit the `start.st` script. It's a good place to start your Zinc servers or any
   long-running smalltalk tasks.

You're now ready to go:

  $ ./app install
  $ ./app start

The instal command can take some time as it will load all your code and its dependencies.

Test if everything runs fine. Beware that there should NOT have any GUI interaction
during the install and start phase. Things will run headless on the server so you
won't be able to do anything.

When you're done, you can:

  $ ./app stop

This will exit the image.

#### On your server

We assume you use Azure but any provider should work as long as it has Ubuntu images.
In a nutshell:

* Create an Azure Ubuntu VM
* Log to it using the username/password given in the administration panel
* Create a user with which you want to deploy (e.g., `deploy`)
* Make this user sudoable (so you can install packages)
* Add your SSH public key in `~/.ssh/authorized_keys` on the server for the deploy user.
  This will let you without entering any password.
* Edit the `hosts.ini` and `vars.yml` file in the ansible directory to match your setup
* Launch automated server setup with: `$ ansible-playbook -i ansible/hosts.ini ansible/server-setup.yml`
* Deploy your app with: `$ ./app deploy`
* Use [DeployUtils](http://smalltalkhub.com/#!/~TaMere/DeployUtils) to handle environment within your image (set the `pharo_env` variable in hosts definitions)

The troubleshooting section contains some stuff that you might have forgotten...

### Details

    $ ansible-playbook -i ansible/hosts.ini ansible/server-setup.yml

will install git, unzip, nginx, pharo-vm and download the base Pharo3 images.
It will also create an nginx configuration file for your project (see
`ansible/templates/nginx-site.conf` for details).

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
  same you defined in `port` variable in `vars.yml`. If you see a mismatch and you
  have already run the server-setup script, you want to rerun it to update the
  nginx configuration file.

## Assets

The nginx configuration will directly serve the files located in `public/` folder.

## Known limitations

There's little chance that we overcome the following limitations:

* Ansible does not run on Windows. You won't be able to deploy an application
  from a Windows machine.
* Out of the box, the script is suitable for single image application (no load
  balancing).
* Use git for versionning (even though your Smalltalk code can be hosted in
  a monticello repository)
* Right now, the server only runs on Ubuntu Linux (using the Pharo PPA)

## To Do

Feel free to work on this and send a pull request to the project. If you badly
want/need one the following, bounties are always possible ;)

* Use version number. Right now we use the `master` branch of the project but we
  really should move to a more robust way to release.
* Provide a "bootstrap" script that performs the steps described in the quick
  install section.
* Be able the choose the branch from which to deploy (currently `master` is always
  used)
* Provide a default preference file (to have, at least, a common package-cache
  for all the images)
* symbolic link to `system` directory. It will contain assets generated by the app
  (e.g., the pictures uploaded by the users)
* Implement rollback. In the meantime add a section in the README with a manual rollback
  procedure
* Separate deploy user with the server-setup user. The deploy user does not need
  sudo root.
* Download and use VMs instead of the Ubuntu PPA so we can deploy on other unix boxes.
