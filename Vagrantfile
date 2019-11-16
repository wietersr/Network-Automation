# -*- mode: ruby -*-
# vi: set ft=ruby :

#using vagrant API version 2
Vagrant.configure("2") do |config|
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search. I'm using an image for centos ver 7
  # On your Win10 machine, you need the HyperV service running before launching vagrant. Open a Powershell console
  # and type: "Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All" then reboot.
  # This vagrant is built around a production network automation environment and uses specific directory structures.
  # This vagrant file should live in: C:\users\%USERNAME%\source\repos\networkvagrant
	# In \repos, also create	NetworkVars (directory for hostvars and groupvars files)
	#				NetworkGetters (directory where "get" or read-only scripts are stored)
	#				NetworkSetters (directory where "set" or write scripts are stored)
	#				NetworkRoles (directory where ansible roles are stored)
	#				NetworkConfigs (directory where config files are built prior to deployment)
	#				NetworkOpstate (directory where device configuration state is stored)
  # My automation environment uses two service accounts to run scripts: 
	# svc_rheltowerro to run getter scripts (read-only permissions to protect us from stupid human tricks)
	# svc_rheltowerrw to run setter scripts (read-write permissions)
	# I do use Azure Devops in my cicd pipeline and have numerous tokens deployed based on these svc accts, but
	# that isn't necessary in for using vagrant file in a general sense.
  # This vagrant is configured to synch teh win file system with the linux file system in vagrant. To do this, you must 
  # share the c:\users\%USERNAME%\source directory. I use everyone & read/write attributes on my share.
  #
  # If you are on a production network, you may encounter proxy or firewall issues when the vagrant starts fetching the centos image
  # or other packages. You'll just have to work through that with your beauracracy. We all have that to deal with in one way or another.
  #
  # To launch vagrant:
	# Launch the windows CMD console as administrator, change to the NetworkVagrant directory
	# type: vagrant up
  # To ssh to vagrant, use Putty to the ip addr (seen in the build output) or type: vagrant ssh in the CMD window
  # To learn other vagrant commands, google it. If you get into trouble, or something doesn't work right the 1st time, Call Persi!
	
  config.vm.box = "centos/7"
  config.vm.hostname = "ansible255"
  config.vm.box_download_insecure = true
  config.ssh.insert_key = false
  #config.ssh.password = "vagrant"
  config.ssh.username = "vagrant"
  #watch for the IP address of your vagrant in the console
  config.vm.provider "hyperv" do |hv| 
    hv.vmname = "ansible255"
  end

    #Copy some required files to guest VM with host specifc slashes (\ or / )
    #and figure out what the windows username will be (based on who is logged into the host)
  if Vagrant::Util::Platform.windows? then
    machinename = ENV["COMPUTERNAME"]
    domain = ENV["USERDNSDOMAIN"]
    fqdn = machinename + "." + domain
    config.vm.provider "hyperv"
    config.vm.network "public_network", bridge: "Default Switch"
    puts "Vagrant launched from windows."
    host = "Windows"
    config.vm.provision "file", source: ".\\Certs", destination: "/home/vagrant/"
    config.vm.provision "file", source: ".\\NewVagrants", destination: "/home/vagrant/"
    creator = ENV["USERNAME"] #ENV["HOMESHARE"].split('\\').last
  else # NOTE: Non-windows machines haven't been tested--not sure this works...
    puts "Vagrant launched from NON-windows machine."
    host = "*nix"
    config.vm.provision "file", source: "./Certs", destination: "/home/vagrant/" 
    config.vm.provision "file", source: "./NewVagrants", destination: "/home/vagrant/"
    T_USER = ENV["USER_PRINCIPAL_NAME"].split('.').first
    creator = T_USER.split('@').first
  end
  
  #Collect password for windows user that will mount shared folders
  if ARGV[0] == 'up' then
    if creator != 'svc_user' then
      puts "NOTICE: You MUST share \\\\" + machinename + "\\Users\\" + creator + "\\source directory in Windows before continuing. Ctrl-C to exit" 
      puts "IF Provisioning a NEW vagrant, please enter password for " + creator
      pass = STDIN.noecho(&:gets)
      puts "Thank you! - We are provisioning your Virtual Machine on " + machinename + "." + domain
    end
  else
    pass = "none"
  end



  #Run shell commands on the guest VM (vagrant)
  #Pass in the user's windows environment variables captured above to form the mount paths specific to user's machine
  config.vm.provision "shell", env: {"SOURCE": creator, "SECRET": pass, "host": host, "FQDN": fqdn}, inline: <<-SHELL

    echo "Welcome "$SOURCE
     
    #setup for mapping to windows drive
    echo 'export WINDOWS_USER='$SOURCE >> /home/vagrant/.bashrc
    echo 'username='$SOURCE > /root/secret.txt
    if [ $host = "Windows" ]
    then 
      sudo tail -n 1 /etc/resolv.conf > /home/vagrant/temp.conf
      sudo echo 'search MKCORP.COM mshome.net 5.5 APR.MKCORP.COM CHN.MKCORP.COM EEU.MKCORP.COM EUR.MKCORP.COM USADMZ.COM STGDMZ.COM MKDEV.COM MKAPPSPROD.COM MKAPPSDEV.COM' > /etc/resolv.conf
      sudo echo 'nameserver 10.4.60.53' >> /etc/resolv.conf
      sudo echo 'nameserver 10.4.9.11' >> /etc/resolv.conf
      sudo echo 'nameserver 10.4.9.12' >> /etc/resolv.conf
      sudo echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
      sudo cat  /home/vagrant/temp.conf >> /etc/resolv.conf
      sudo cp /etc/resolv.conf /home/vagrant/NewVagrants/resolv.conf
    fi
    #if Not svc_rheltowerrw user doing CICD, make local directories for personal and team share mounted drives
    if [ $SOURCE != 'svc_rheltowerrw' ]; then
      sudo mkdir /mnt/m
      #assume root and send path and append to fstab
      #must share the below path in windows prior to initiating vagrant up
      sudo echo "\\\\\\\\$FQDN\\users\\\\$SOURCE\\source\\repos /mnt/m cifs credentials=/root/secret.txt,uid=1000,gid=1000,nocase" >> /etc/fstab
      echo 'password='$SECRET >> /root/secret.txt
    else
      sudo echo 'password=<sanitized>' >> /root/secret.txt
    fi
    sudo mkdir /mnt/netshare
    # escape the backslashes in windows path and append to fstab
    sudo echo '\\\\mycorporation.com\\shares\\group_shares\\myshare /mnt/myshare cifs credentials=/root/secret.txt,uid=1000,gid=1000,nocase' >> /etc/fstab


    ### allow password authentication (for putty)
    sudo sed -i 's/^[pP]asswordAuthentication no/passwordAuthentication yes/' /etc/ssh/sshd_config 
    sudo service sshd restart
    ### Windows host needs these 
    cp /home/vagrant/Certs/* /etc/pki/ca-trust/source/anchors/
    #rm -r /home/vagrant/Certs
    sudo update-ca-trust enable
    sudo update-ca-trust extract

  ###&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  ###&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    
  
    ### install git, epel, pip
    # vi /etc/yum.repos.d/epel.repo and remove the s in all https
	  # sudo sed -i -e 's/https/http:/g' /etc/yum.repos.d/epel.repo 
  echo "----------------------------------------------------"
	echo "  Installing Git version control software"
	echo "----------------------------------------------------"
    sudo yum -y -q install git
  echo "------------------------------------------------------------"
	echo "  Installing Extra Packages for Enterprise Linux Repo (EPEL)"
	echo "------------------------------------------------------------"
	  sudo yum -y -q install epel-release 
	echo "----------------------------------------------------------------"
	echo "  Installing PIP package Manager for Python Package Index (PYPI)"
	echo "----------------------------------------------------------------"
    sudo yum -y -q install python-pip python-wheel
	echo "----------------------------------------------------"
	echo "  Upgrading PIP"
	echo "----------------------------------------------------"    
    sudo pip install --upgrade pip -q

    ##use pip to install python modules
  echo "----------------------------------------------------"
	echo "  Installing Python Requests Module"
	echo "----------------------------------------------------"
	  sudo pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org requests -q
	echo "----------------------------------------------------"
	echo "  Upgrade Setup Tools"
	echo "----------------------------------------------------"
    sudo pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -U pip setuptools
	echo "----------------------------------------------------"
	echo "  Installing Orion SDK"
	echo "----------------------------------------------------"
    sudo pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org orionsdk -q
    
    ### samba allows *nix systems to connect to windows shared folders
  echo "----------------------------------------------------"
	echo "  Installing Samba"
	echo "----------------------------------------------------"
	sudo yum -y -q install samba samba-client
	# echo "----------------------------------------------------"
	# echo "  Installing CIFs-Utilities"     NOT NEEDED--ALREADY INSTALLED
	# echo "----------------------------------------------------"
  #   sudo yum -y install cifs-utils
    
    ### install ansible - a specific package 2.5.5
	echo "----------------------------------------------------"
	echo "  Installing Ansible ver 2.5.5"
	echo "----------------------------------------------------"
    sudo yum install -y -q https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.5.5-1.el7.ans.noarch.rpm

  #install NetworkToCode modules - from source
  echo "----------------------------------------------------"
  echo "  Installing NetworkToCode modules"
  echo "----------------------------------------------------"
  # cd /usr/share/
  # sudo git clone https://github.com/networktocode/ntc-ansible --recursive
  # cd ntc-ansible
  # sudo python setup.py -q install  
  sudo pip install ntc-ansible -q
      
    #install NetworkToCode dependancy - netmiko
	echo "----------------------------------------------------"
	echo "  Installing Netmiko"
	echo "----------------------------------------------------"
    # cd /usr/share/
    # sudo git clone https://github.com/ktbyers/netmiko.git
    # cd /usr/share/netmiko
    # sudo python setup.py -q install
    sudo pip install netmiko -q

    

    #install useful *nix utils
	echo "----------------------------------------------------"
	echo "  Installing Bind Utilities"
	echo "----------------------------------------------------"
    sudo yum -y -q install bind-utils
	echo "----------------------------------------------------"
	echo "  Installing Auto File System"
	echo "----------------------------------------------------"
    sudo yum -y -q install autofs
	echo "----------------------------------------------------"
	echo "  Installing Tree Utility"
	echo "----------------------------------------------------"
    sudo yum -y -q install tree

    ##configure Ansible & Ansible-vault
	echo "----------------------------------------------------"
	echo "  Configuring Ansible & Ansible Vault"
	echo "----------------------------------------------------"
    sudo mv /home/vagrant/NewVagrants/ansible.cfg /etc/ansible/ansible.cfg
    sudo mkdir /home/awx
    sudo mv /home/vagrant/NewVagrants/svc_rheltowerro /home/awx/svc_rheltowerro
    sudo chown vagrant:vagrant /home/awx/svc_rheltowerro
    sudo chmod 644 /home/awx/svc_rheltowerro

  ###&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  ###&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

    ##mount windows shares
    echo "----------------------------------------------------"
    echo "Configuring File Systems"
    echo "----------------------------------------------------"
    # I have a team share that I mount. Uncomment and customize the following lines for your env if you like:
    #sudo mount /mnt/netshare
    # make sure it gets done on subsequent boots too 
    #echo 'sudo mount /mnt/netshare' >> /home/vagrant/.bash_profile
    #if [ $SOURCE != 'svc_rheltowerrw' ]; then
      #if [  $host = "Windows" ]; then 
        #echo 'sudo cp NewVagrants/resolv.conf /etc/resolv.conf' >> /home/vagrant/.bash_profile
      #fi
    #fi
    sudo mount /mnt/m
    #make sure it gets done on subsequent boots too
    echo 'sudo mount /mnt/m' >> /home/vagrant/.bash_profile
     ##create links to Windows Shares
     if [ -d "/mnt/m/" ]; then
      echo 'repos directory exists'
       if [ ! -d "/mnt/m/NetworkGetters/" ]; then
          echo 'make directory for NetworkGetters'
          sudo mkdir "/mnt/m/NetworkGetters"
          chown vagrant:vagrant "/mnt/m/NetworkGetters"
       fi
       if [ ! -d "/mnt/m/NetworkOpState" ]; then
         echo 'mkdir NetworkOpState'
         sudo mkdir "/mnt/m/NetworkOpState"
         chown vagrant:vagrant "/mnt/m/NetworkOpState"
       fi
       if [ ! -d "/mnt/m/NetworkRoles" ]; then
         echo 'mkdir NetworkRoles'
         sudo mkdir "/mnt/m/NetworkRoles"
         chown vagrant:vagrant "/mnt/m/NetworkRoles"
       fi
       if [ ! -d "/mnt/m/NetworkSetters" ]; then
         echo 'mkdir NetworkSetters'
         sudo mkdir "/mnt/m/NetworkSetters"
         chown vagrant:vagrant "/mnt/m/NetworkSetters"
       fi
       if [ ! -d "/mnt/m/NetworkVagrant" ]; then
         echo 'mkdir NetworkVagrant'
         sudo mkdir "/mnt/m/NetworkVagrant"
         chown vagrant:vagrant "/mnt/m/NetworkVagrant"
       fi
       if [ ! -d "/mnt/m/NetworkVars" ]; then
         echo 'mkdir NetworkVars'
         sudo mkdir "/mnt/m/NetworkVars"
         chown vagrant:vagrant "/mnt/m/NetworkVars"
       fi
       if [ ! -d "/mnt/m/NetworkConfigs" ]; then
         echo 'mkdir NetworkConfigs'
         sudo mkdir "/mnt/m/NetworkConfigs"
         chown vagrant:vagrant "/mnt/m/NetworkConfigs"
       fi
      else
        echo 'creating repos and child directories'
        #sudo mkdir "/mnt/m/$SOURCE/source/repos/"
        sudo mkdir "/mnt/m/NetworkGetters"
        sudo mkdir "/mnt/m/NetworkOpState"
        sudo mkdir "/mnt/m/NetworkRoles"
        sudo mkdir "/mnt/m/NetworkSetters"
        sudo mkdir "/mnt/m/NetworkVagrant"
        sudo mkdir "/mnt/m/NetworkVars"
        sudo mkdir "/mnt/m/NetworkConfigs"

        echo 'chowning repo folders'
        #sudo chown vagrant:vagrant "/mnt/m/$SOURCE/source/repos/"
        sudo chown vagrant:vagrant "/mnt/m/NetworkGetters"
        sudo chown vagrant:vagrant "/mnt/m/NetworkOpState"
        sudo chown vagrant:vagrant "/mnt/m/NetworkRoles"
        sudo chown vagrant:vagrant "/mnt/m/NetworkSetters"
        sudo chown vagrant:vagrant "/mnt/m/NetworkVagrant"
        sudo chown vagrant:vagrant "/mnt/m/NetworkVars"
        sudo chown vagrant:vagrant "/mnt/m/NetworkConfigs"
      fi

      echo 'linking repo directories between windows/linux file systems'
      if [ ! -L "/home/vagrant/NetworkGetters" ]; then
        sudo ln -s "/mnt/m/NetworkGetters" /home/vagrant/NetworkGetters
        sudo chown vagrant:vagrant /home/vagrant/NetworkGetters

      if [ ! -L "/etc/ansible/NetworkOpState" ]; then
       sudo ln -s "/mnt/m/NetworkOpState" /etc/ansible/NetworkOpState
       sudo chown vagrant:vagrant /etc/ansible/NetworkOpState
      fi
      if [ ! -L "/etc/ansible/NetworkRoles" ]; then
       sudo ln -s "/mnt/m/NetworkRoles" /etc/ansible/NetworkRoles
       sudo chown vagrant:vagrant /etc/ansible/NetworkRoles
      fi
      if [ ! -L "/home/vagrant/NetworkSetters" ]; then
       sudo ln -s "/mnt/m/NetworkSetters" /home/vagrant/NetworkSetters
       sudo chown vagrant:vagrant /home/vagrant/NetworkSetters
      fi    
      if [ ! -L "/vagrant" ]; then
       sudo ln -s "/mnt/m/NetworkVagrant" /vagrant
       sudo chown vagrant:vagrant /vagrant
      fi
      if [ ! -L "/etc/ansible/NetworkVars" ]; then
       sudo ln -s "/mnt/m/NetworkVars" /etc/ansible/NetworkVars
       sudo chown vagrant:vagrant /etc/ansible/NetworkVars
      fi
      if [ ! -L "/etc/ansible/NetworkConfigs" ]; then
       sudo ln -s "/mnt/m/NetworkConfigs" /etc/ansible/NetworkConfigs
       sudo chown vagrant:vagrant /etc/ansible/NetworkConfigs
      fi    
    else  # You may never hit this code block--I do as sometimes I run as svc_rheltowerrw and need to acct for it...
      # we ARE svc_rheltowerrw doing CICD? 
       sudo mkdir "/etc/ansible/NetworkGetters"
       sudo mkdir "/etc/ansible/NetworkOpState"
       sudo mkdir "/etc/ansible/NetworkRoles"
       sudo mkdir "/etc/ansible/NetworkSetters"
       sudo mkdir "/etc/ansible/NetworkVagrant"
       sudo mkdir "/etc/ansible/NetworkVars"
       sudo mkdir "/etc/ansible/NetworkConfigs"

       sudo chown vagrant:vagrant "/etc/ansible/NetworkGetters"
       sudo chown vagrant:vagrant "/etc/ansible/NetworkOpState"
       sudo chown vagrant:vagrant "/etc/ansible/NetworkRoles"
       sudo chown vagrant:vagrant "/etc/ansible/NetworkSetters"
       sudo chown vagrant:vagrant "/etc/ansible/NetworkVagrant"
       sudo chown vagrant:vagrant "/etc/ansible/NetworkVars"
       sudo chown vagrant:vagrant "/etc/ansible/NetworkConfigs"
    fi
    # The following code block runs an ansible script (after ansible installs above) and runs a playbook that clones all my repos
    # from the master git repository. It's not needed for this basic vagrant use case, but serves as example.
    # Use playbook to clone repos.
    #echo "----------------------------------------------------"
	  #echo "cloning repos"
    #echo "----------------------------------------------------"
    #sudo ansible-playbook /home/vagrant/NewVagrants/ansible_setup.yml
  SHELL
end
