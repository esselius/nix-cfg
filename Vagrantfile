Vagrant.configure("2") do |config|
    config.vm.provider :virtualbox do |vb|
      vb.memory = "8192"
    end

    config.vm.define :nixos, primary: true do |nixos|
      nixos.vm.box = "esselius/nixos"
      nixos.vm.box_version = "20.09"

      nixos.vm.provision :shell,
        inline: "cd /vagrant && sudo nix-shell --command switch-nixos"
    end

    config.vm.define :ubuntu, autostart: false do |ubuntu|
      ubuntu.vm.box = "ubuntu/focal64"
      ubuntu.vm.box_version = "20210222.0.0"

      ubuntu.vm.provision :shell, privileged: false,
        inline: "sh <(curl -sSfL https://nixos.org/nix/install) --daemon --nix-extra-conf-file nix.conf"

      ubuntu.vm.provision :shell, privileged: false,
        inline: "cd /vagrant && nix-shell --command switch-home"
    end

    config.vm.define :catalina, autostart: false do |catalina|
        catalina.vm.box = "ramsey/macos-catalina"

        catalina.vm.synced_folder ".", "/Users/vagrant/nix-cfg", type: "rsync"

        catalina.vm.provision :shell, privileged: false,
          inline: "sh <(curl -sSfL https://nixos.org/nix/install) --daemon --nix-extra-conf-file nix.conf --darwin-use-unencrypted-nix-store-volume"

        catalina.vm.provision :shell, privileged: false, inline:
          "zsh -i -c 'nix-env -iA nixpkgs.gitMinimal'"

        catalina.vm.provision :shell, inline:
          "mdutil -i off /nix"

        catalina.vm.provision :shell, privileged: false, inline:
          "zsh -i -c 'cd nix-cfg && nix-shell -p git --command \"nix-shell --command switch-darwin --show-trace\"'"
      end
  end