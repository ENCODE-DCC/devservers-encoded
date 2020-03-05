#!/bin/bash
export user_name='vagrant'
export home_dir='/home/vagrant'
export venv_dir="$home_dir/encoded-venv"
export install_files_dir="$home_dir/mac-files"
export encd_dir="$install_files_dir/encoded"

export es_install_dir='/opt/elasticsearch'
export es_package_name='elasticsearch-5.4.3'

export pg_bin_dir='/usr/lib/postgresql/11/bin'

msg='vagrant-install Basic system install'
echo -e "\n\n$msg"
if [ -d "$venv_dir" ]; then
    echo -e "\tAlready installed"
else
    sudo apt-get update
    sudo apt-get install curl
fi
echo -e "\n"
echo -e "DONE $msg"

msg='vagrant-install Installing JAVA: openjdk-11-jre-headles'
echo -e "\n\n$msg"
if [ -d "$venv_dir" ]; then
    echo -e "\tAlready installed"
else
    sudo apt install -y openjdk-11-jre-headless
fi
echo -e "\n"
java -version
echo -e "DONE $msg"

msg="vagrant-install Installing Elasticsearch 5.4.3: $es_install_dir"
echo -e "\n\n$msg"
if [ -f "$es_install_dir/$es_package_name/bin/elasticsearch" ]; then
    echo -e "\tAlready installed"
else
    sudo mkdir -p $es_install_dir
    sudo chown "$user_name:$user_name" "$es_install_dir"
    cd "$es_install_dir"
    curl -L -O "https://artifacts.elastic.co/downloads/elasticsearch/$es_package_name.tar.gz"
    tar -xvf "$es_package_name.tar.gz"
    export PATH=$es_install_dir/$es_package_name/bin:$PATH
    echo "export PATH=$es_install_dir/$es_package_name/bin:$PATH" >> "$home_dir/.bashrc"
    source "$home_dir/.bashrc"
    sudo -u root chown -R vagrant:vagrant "$es_install_dir/$es_package_name"
fi
echo -e "\n"
elasticsearch -V
echo -e "DONE $msg"

msg='vagrant-install Installing Postgresql 11'
echo -e "\n\n$msg"
if [ -f "$pg_bin_dir/initdb" ]; then
    echo -e "\tAlready installed"
else
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo add-apt-repository 'deb http://apt.postgresql.org/pub/repos/apt bionic-pgdg main'
    sudo apt-get update
    sudo apt install -y postgresql-11
    export PATH="$pg_bin_dir:$PATH"
    echo "export PATH=$pg_bin_dir/bin:$PATH" >> "$home_dir/.bashrc"
    source "$home_dir/.bashrc"
fi
echo -e "\n"
psql -V
echo -e "DONE $msg"

msg='vagrant-install Installing Node 10'
echo -e "\n\n$msg"
if [ -d "$venv_dir" ]; then
    echo -e "\tAlready installed"
else
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    sudo apt install -y nodejs g++ gcc make
fi
echo -e "\n"
psql -V
echo -e "DONE $msg"

msg='vagrant-install Installing apt stuff'
echo -e "\n\n$msg"
if [ -d "$venv_dir" ]; then
    echo -e "\tAlready installed"
else
    cat $install_files_dir/devservers-encoded/apt-installs.txt | xargs sudo apt install -y
fi
echo -e "\n"
echo -e "DONE $msg"

msg='vagrant-install Permit nginx log writing'
echo -e "\n\n$msg"
if [ -d "$venv_dir" ]; then
    echo -e "\tAlready installed"
else
    sudo apt install nginx
    sudo ufw allow ssh
    sudo ufw allow 22
    sudo ufw allow 2222
    sudo ufw allow 6543
    sudo ufw enable
    sudo mkdir -p /var/log/nginx
    sudo chmod -R 777 /var/log/nginx/
    sudo mkdir -p /var/lib/nginx
    sudo chmod 777 /var/lib/nginx/
    sudo -u root touch /run/nginx.pid
    sudo -u root chown vagrant:vagrant /run/nginx.pid
fi
echo -e "\n"
echo -e "DONE $msg"

msg='vagrant-install Create python3 venv'
echo -e "\n\n$msg"
if [ -d "$venv_dir" ]; then
    echo -e "\tAlready installed"
else
    python3 -m venv "$venv_dir"
    "$venv_dir/bin/pip" install -U pip setuptools
    "$venv_dir/bin/pip" install -r $install_files_dir/encoded/requirements.osx.catalina.txt
fi
echo -e "\n"
echo -e "DONE $msg"

msg='vagrant-install Add helpers to bashrc'
echo -e "\n\n$msg"
echo "source $venv_dir/bin/activate" >> "$home_dir/.bashrc"
echo "alias rebuild_encd='cd $encd_dir && make clean && buildout bootstrap && bin/buildout'" >> "$home_dir/.bashrc"
echo "alias kill_elasticsearch='pkill -f elasticsearch'" >> "$home_dir/.bashrc"
echo "alias dev_servers='cd $encd_dir && bin/dev-servers development.ini --app-name app --clear --init --load'" >> "$home_dir/.bashrc"
echo "alias p_serve='cd $encd_dir && bin/pserve development.ini'"  >> "$home_dir/.bashrc"
echo -e "DONE $msg"
