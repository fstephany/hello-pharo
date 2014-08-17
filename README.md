# HelloPharo

HelloPharo is a code farm for Pharo that makes small webapp deployment easy.

It is inspired by [Capistrano](http://capistranorb.com/) and is built on top of
[Ansible](http://www.ansible.com/home). When designing this tool we preferred
convention over configuration.

This code farm is a starting point. We expect you to tweak the configuration to
fit your need, we just provide sensible default. When you download HelloPharo,
you see the actual code used to deploy a trivial webapp.

We concentrate on the current stable release of Pharo. This means we've hardcoded the
pharo version to Pharo 3.0p852.

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
   You can rename the directory to match your project name. In these instructions
   we'll assume that the directory is called `hello-pharo`.
2. Download the latest pharo 3 image, changes and sources file. We use
   http://files.pharo.org/image/30/30852.zip and
   http://files.pharo.org/sources/PharoV30.sources.zip
3. Rename the files as `pharo.image` and `pharo.changes` and copy them in the newly
   created `hello-pharo` directory. Copy the `PharoV30.sources` as well.
4. Open a terminal and navigate to the `hello-pharo` directory.
5. Avoid getting some junk in your git repository: `$ cp gitignore.example .gitignore`.
   Edit the gitignore file as you wish but don't include the image/changes files in
   the git repo.
6. Edit the `install.st` script to load your code. We usually put our code in
   the `src/` directory but feel free to load anything from anywhere (e.g., Smalltalkhub).
   Do not delete the "save and quit" instruction from the script, otherwise your
   server will hangs when you deploy.
7. Edit the `start.st` script. It's a good place to start your Zinc servers or any
   long-running smalltalk tasks.

Check the *Local Directory Structure*  section for more details about the directory structure you should adopt and the convention to follow.

You're now ready to go:

    $ ./app install
    $ ./app start

The install command can take some time as it will load all your code and its dependencies.

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
* Edit the `hosts.ini` and `vars.yml` file in the ansible directory to match your setup.
* Make sure, you've pushed your code in the git repository defined in the `repo`
  variable of the `ansible/vars.yml` file.
* Launch automated server setup with: `$ ansible-playbook -i ansible/hosts.ini ansible/server-setup.yml`
* See the troubleshooting section if something goes wrong.
* Deploy your app with: `$ ./app deploy`
* Use [DeployUtils](http://smalltalkhub.com/#!/~TaMere/DeployUtils) to handle environment within your image (set the `pharo_env` variable in hosts definitions)

Everytime you want to deploy the master branch of your app, run

    $ ./app deploy

### Details

    $ ansible-playbook -i ansible/hosts.ini ansible/server-setup.yml

will install git, unzip, nginx, pharo-vm and download the base Pharo3 images.
It will also create an nginx configuration file for your project (see
`ansible/templates/nginx-site.conf` for details).

## Local Directory Structure

HelloPharo expects a strict directoy structure for your project. This section explains it. Notice that `pharo.changes`, `pharo.image` and `PharoV30.sources` *must* be in the `.gitignore` file.

    ├── LICENSE
    ├── PharoV30.sources
    ├── README.md
    ├── ansible
    │   ├── deploy.yml
    │   ├── hosts.ini
    │   ├── server-setup.yml
    │   ├── templates
    │   │   └── nginx-site.conf
    │   └── vars.yml
    ├── app
    ├── config
    │   ├── development.json
    │   └── production.json
    ├── install.st
    ├── pharo.changes
    ├── pharo.image
    ├── public
    │   ├── 404.html
    │   ├── 500.html
    │   └── assets
    │       └── pharo-logo.png
    ├── src
    │   └── # Your Pharo/Filetree code
    └── start.st

### `pharo.changes`, `pharo.image`, `PharoV30.sources`

By default, those three  files are not there, download:

* [The image and changes files](http://files.pharo.org/image/30/30852.zip)
* [The sources file](http://files.pharo.org/sources/PharoV30.sources.zip)

Rename the changes and image files to `pharo.changes` and `pharo.image`. Move them to the project directory.

List these three files in the `.gitignore` or simply copy the `gitignore.example` file.


### `install.st` and `start.st`

The `install.st` script will be used to build the image containing your application. You should load your code and all its dependencies in here. The default `install.st` file shows you how it is done for the super simple example we provide. **Don't forget to save & quit the image at the end of this script**.

`start.st` is executed when you start the app. You should start your Zinc server/Seaside adapter/database connection/whatever in here. Note that you **should not save the image in `start.st`**

### `app`

This bash script is one of the central piece of HelloPharo. It can install/start/stop a project. Most useful commands:

    $ ./app install  
    # will execute the install.st script against the image
    
    $ ./app start 
    # will execute the start.st script against the image and store the PID of the process
    
    $ ./app stop 
    # will kill the saved PID
   
Those three commands works on your development machine as well as on the remote server. We advise you to use them during development to make sure they are working well before trying to deploy.

    $ ./app deploy
    # will start the deployment process 

### `ansible/` directory

This directory contains all the server administration code. You should update the `vars.yml` and `hosts.ini` to match your setup. Please read the *Server Directory Structure* for more details.

### `public/` directoy

Put all your static file that should be rendered by the webserver here. Note that items in `public/assets` will be gzipped before being served. It's a good place for your CSS/Javascripts files. 

Nginx will render the `404.html` and `500.html` from this directory. You probably want to tune them.

### `config/` directory

Place here your environment files. Usually named `production.json`, `staging.json` and `development.json` these files contain the configuration of your app for each environment. Use the [DeployUtils](http://smalltalkhub.com/#!/~TaMere/DeployUtils) smalltalk package to use them within your image.

Environment files are the right place to put the database connection information (username, port, host, password) or external API Key you use (transactional email provider for example).


## Server Directory Structure

TODO: show the the directory hierarchy on the server.


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
* Are `pharo.changes`, `pharo.image` and `PharoV30.sources` in your `.gitignore
  file.

Ping me on twitter [@fstephany](http://twitter.com/fstephany) or send an email
to the pharo-users mailing list if something goes wrong.


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

* Add an ansible vault for productin app config file
* Use Monit for process monitoring
* Use version number. Right now we use the `master` branch of the project but we
  really should move to a more robust way to release.
* Provide a "bootstrap" script that performs the steps 2 and 3 of the quick
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

## Credits

Hello-Pharo is developed by [Ta Mère SCRL](http://tamere.eu). We

* build apps for clients,
* provide training/coaching,
* eat a lot of french fries.

The `app` shell script is heavily inspired by `st-exec.sh` from [http://stfx.eu/pharo-server/](http://stfx.eu/pharo-server/) by Sven Van Caekenberghe

