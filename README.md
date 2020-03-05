Encoded development servers setup
=================================
Deploy development servers in Ubuntu 18 on OSX using vagrant and virtual box


## Dependencies
    1. git
    2. virtualbox: https://www.virtualbox.org/wiki/Downloads
        * https://download.virtualbox.org/virtualbox/6.1.4/VirtualBox-6.1.4-136177-OSX.dmg
    3. vagrant: https://www.vagrantup.com/downloads.html
        * https://releases.hashicorp.com/vagrant/2.2.7/vagrant_2.2.7_x86_64.dmg

### Check installation
    $ vagrant -v
    # Vagrant 2.2.7
    $ vagrant box add ubuntu/bionic64

    $ type virtualbox
    # virtualbox is /usr/local/bin/virtualbox

## System Installation
    # Setup work area. The relative location of repos is important.
    $ mkdir ~/mywork/devservers-encoded
    $ cd ~/mywork/devservers-encoded
    $ git clone git@github.com:ENCODE-DCC/devservers-encoded.git
    $ git clone git@github.com:ENCODE-DCC/encoded.git
    $ cp devservers-encoded/Vagrantfile ./
    $ vagrant up

## Running
    # ssh onto vagrant instance
    # Must be in directry that you called 'vagrant up'
    $ vagrant ssh

    # Build the application
    $ (encoded-venv) vagrant$ rebuild_encd

    # Start dev servers
    $ (encoded-venv) vagrant$ dev_servers

    # In a second terminal ssh onto vagrant instance
    # Must be in directry that you called 'vagrant up'
    $ vagrant ssh
    $ (encoded-venv) vagrant$ p_serve

    # Open app in browser
    http://localhost:6543/

## Development
    * On OSX in the encoded repo make updates to your feature as usuaual
    * On vagrant instances rerun, rebuild_encd, dev_servers, and p_serve as needed to view updates
    * Also, npm build or npm run dev can be run on vagrant instance as needed.
    * bin/test has not been tested.
