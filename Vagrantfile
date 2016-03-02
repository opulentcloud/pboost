# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 5432, host: 5432
  config.vm.network "forwarded_port", guest: 8000, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
      vb.memory = "4096"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL

  config.vm.provision "shell", inline: <<-SHELL
    apt-get -y update
    apt-get -y install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev libxslt-dev libxml2-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
  
    if [ -z `which convert` ]; then
      apt-get -y install imagemagick libmagickwand-dev
    fi

    if [ -z `which git` ]; then
      echo "===== Installing Git"
      apt-get -y install git-core
    fi    

    if [ -z `which nodejs` ]; then
      apt-get -y install nodejs
    fi    

    if [ -z `which phantomjs` ]; then      
      apt-get -y install phantomjs
    fi    

    /usr/sbin/update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
    PG_VERSION=9.5
    PG_REPO_APT_SOURCE=/etc/apt/sources.list.d/pgdg.list
    if [ ! -f "$PG_REPO_APT_SOURCE" ]
    then
      # Add PG apt repo:
      echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > "$PG_REPO_APT_SOURCE"

      # Add PGDG repo key:
      wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
    fi

    # Update package list and upgrade all packages
    apt-get update
    apt-get -y upgrade

    apt-get -y install "postgresql-$PG_VERSION" "postgresql-contrib-$PG_VERSION" "postgresql-$PG_VERSION-postgis-2.2"
    apt-get -y install libpq-dev

    PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
    PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
    PG_DIR="/var/lib/postgresql/$PG_VERSION/main"

    # Edit postgresql.conf to change listen address to '*':
    sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

    # Append to pg_hba.conf to add password auth:
    echo "host    all             all             all                     password" >> "$PG_HBA"

    service postgresql restart

    echo "Y" | echo "createuser vagrant" | su - postgres
    echo "ALTER USER vagrant PASSWORD 'vagrant';" | su - postgres -c psql
    echo "ALTER ROLE vagrant SUPERUSER CREATEDB;" | su - postgres -c psql

  SHELL

  config.vm.provision "reset", type: "shell" do |s|
    s.privileged = false
    s.inline = <<-SHELL
      RUBY_VERSION='2.3.0'
      GEMS_VERSION='2.5.1'

      # Setup Ruby using rbenv
      echo "===== Installing Ruby $RUBY_VERSION"

      # Start in the home directory
      cd

      git clone git://github.com/sstephenson/rbenv.git .rbenv
      echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
      echo 'eval "$(rbenv init -)"' >> ~/.bashrc

      git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
      echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

      export PATH="$HOME/.rbenv/bin:$PATH"
      eval "$(rbenv init -)"
      export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

      rbenv install $RUBY_VERSION
      rbenv global $RUBY_VERSION


      echo "===== Installing Rubygems $GEMS_VERSION"
      wget http://production.cf.rubygems.org/rubygems/rubygems-${GEMS_VERSION}.tgz
      tar xzf rubygems-${GEMS_VERSION}.tgz
      cd rubygems-$GEMS_VERSION
      ruby setup.rb
      cd ..
      rm -rf rubygems-${GEMS_VERSION}*

      if [ -z `which bundle` ]; then
        gem install bundler --no-rdoc --no-ri
      fi

      if [ -z `which foreman` ]; then
        gem install foreman --no-rdoc --no-ri
      fi
    SHELL
  end
end
