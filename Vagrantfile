Vagrant.configure("2") do |config|
  config.vm.box = "esselius/nixos-20.09"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8192"
  end

  config.vm.provision "shell",
    inline: "cd /vagrant && sudo nix-shell --command switch-nixos"
end
