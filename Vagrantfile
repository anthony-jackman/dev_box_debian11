# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/bullseye64"
  config.vm.box_check_update = false
  config.vm.box_version = "11.20210829.1"
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  # config.vm.network "forwarded_port", guest: 80, host: 8080, id: "web", host_ip: "127.0.0.1"
  # config.vm.network "forwarded_port", guest: 443, host: 8081, id: "secure", host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 3030, host: 3031, id: "api1", host_ip: "127.0.0.1"
  # config.vm.network "forwarded_port", guest: 3001, host: 3004, id: "api2", host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 27017, host: 37017, id: "db1", host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder "./nodeapi", "/home/vagrant/nodeapi"

  config.vm.provider "virtualbox" do |v|
    mem_ratio = 0.5
    cpu_exec_cap = 75
    host = RbConfig::CONFIG['host_os']
    # Give VM 1/2 system memory & access to all cpu cores on the host
    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
      # sysctl returns Bytes and we need to convert to MB
      mem = (`sysctl -n hw.memsize`.to_i / 1024^2 * mem_ratio).round
    elsif host =~ /linux/
      cpus = `nproc`.to_i
      # meminfo shows KB and we need to convert to MB
      mem = (`grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 * mem_ratio).round
    else # Windows folks
      cpus = `wmic cpu get NumberOfCores`.split("\n")[2].to_i
      mem = (`wmic OS get TotalVisibleMemorySize`.split("\n")[2].to_i / 1024 * mem_ratio).round
    end
  
    puts "Provisioning VM with #{cpus} CPU's (at #{cpu_exec_cap}%) and #{mem/1024} GB RAM."
  
    v.customize ["modifyvm", :id, "--memory", mem]
    v.customize ["modifyvm", :id, "--cpus", cpus]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
    v.customize ["modifyvm", :id, "--cpuexecutioncap", cpu_exec_cap]
  end

  config.vm.provision "shell", name: "basic", path: "./vm_provision/base.sh"
  config.vm.provision "shell", name: "git-scm", path: "./vm_provision/git.sh"
  config.vm.provision "shell", name: "ufw", path: "./vm_provision/ufw.sh"
  config.vm.provision "shell", name: "mongodb", path: "./vm_provision/mongo.sh"
  config.vm.provision "shell", name: "nodejs", path: "./vm_provision/nodejs.sh"

  config.vm.provision "shell", name: "node-config", path: "./vm_provision/node_proj_setup.sh"


  config.vm.provision "shell", name: "firewall-dev", path: "./vm_provision/firewall-config.sh"
  # config.vm.provision "shell", name: "nginx", path: "./vm_provision/nginx.sh"
  # config.vm.provision "shell", name: "secureweb-dev", path: "./vm_provision/utls/secureweb-dev.sh"
  # config.vm.provision "shell", name: "secureweb-prod", path: "./vm_provision/utls/secureweb-prod.sh"
  # config.vm.provision "shell", name: "securedb-dev", path: "./vm_provision/utls/securemongo-dev.sh"

  # config.vm.provision "shell", name: "git-scm", path: "./vm_provision/utls/SourceInstall-git.sh"
  # config.vm.provision "shell", name: "git-scm", path: "./vm_provision/utls/SourceInstall-nginx.sh"
  
end
