Vagrant.configure("2") do |config|
    config.vagrant.plugins = ["vagrant-vmware-desktop"]

    # NixOS
    config.vm.define :nixos, primary: true do |nixos|
      nixos.vm.box = "esselius/nix-cfg-nixos"

      nixos.vm.provider :vmware_desktop do |vmware|
        vmware.vmx["memsize"] = "8192"
        vmware.vmx["numvcpus"] = "4"
      end

      nixos.vm.synced_folder ".", "/home/vagrant/nix-cfg", type: "rsync"

      nixos.vm.provision :shell,
        inline: "cd nix-cfg && sudo nix-shell --command switch-nixos"
    end

    # Ubuntu
    config.vm.define :ubuntu, autostart: false do |ubuntu|
      ubuntu.vm.box = "generic/ubuntu2004"
      ubuntu.vm.box_version = "3.2.6"

      ubuntu.vm.synced_folder ".", "/vagrant"

      ubuntu.vm.provision :shell, privileged: false,
        inline: "sh <(curl -sSfL https://nixos.org/nix/install) --daemon --nix-extra-conf-file /vagrant/nix.conf"

      ubuntu.vm.provision :shell, privileged: false,
        inline: "cd /vagrant && nix-shell --command switch-home"
    end

    # MacOS
    config.vm.define :catalina, autostart: false do |catalina|
        catalina.vm.box = "tas50/macos_10.15"
        catalina.vm.box_version = "1.1.0"

        catalina.vm.synced_folder ".", "/Users/vagrant/nix-cfg", type: "rsync"

        catalina.vm.provision :shell, privileged: false,
          inline: "sh <(curl -sSfL https://nixos.org/nix/install) --daemon --darwin-use-unencrypted-nix-store-volume"

        # Not required if logged in to UI
        catalina.vm.provision :shell, privileged: false, inline:
          "zsh -i -c 'nix-env -iA nixpkgs.gitMinimal'"

        # Disable /nix spotlight indexing and drop default nix.conf (recreated by nix-darwin)
        catalina.vm.provision :shell, inline:
          "mdutil -i off /nix && rm /etc/nix/nix.conf"

        catalina.vm.provision :shell, privileged: false, inline:
          "zsh -i -c 'cd nix-cfg && nix-shell --command switch-darwin'"
      end
  end