Vagrant.configure("2") do |config|
    config.vagrant.plugins = ["vagrant-vmware-desktop"]

    # NixOS
    config.vm.define :nixos, primary: true do |nixos|
      nixos.vm.box = "esselius/nix-cfg-nixos"

      nixos.vm.provider :vmware_desktop do |vmware|
        vmware.gui = true
        vmware.vmx["memsize"] = "8192"
        vmware.vmx["numvcpus"] = "4"

        # Enable USB controller
        vmware.vmx["usb.present"] = "TRUE"

        # Use yubikey inside VM, in 2 modes:
        #
        # 1. Yubikey -> virtual smartcard @ VM
        # Enables yubikey PIV to be used by both host and guest OS's
        # vmware.vmx["usb.autoConnect.device0"] = "deviceType:virtual-smartcard"
        #
        # 2. Raw YubiKey passthrough
        # Enables yubikey PIV admin and enables other non-PIV features, like U2F/FIDO2
        vmware.vmx["usb.generic.allowCCID"] = "TRUE"
        vmware.vmx["usb.generic.allowHID"] = "TRUE"
        vmware.vmx["usb.generic.allowLastHID"] = "TRUE"
      end

      nixos.vm.synced_folder ".", "/home/vagrant/nix-cfg", type: "rsync"

      nixos.vm.provision :shell,
        inline: "cd nix-cfg && sudo nix-shell --command switch-nixos"
    end

    # Ubuntu LTS
    config.vm.define :ubuntu2004, autostart: false do |ubuntu|
      ubuntu.vm.box = "generic/ubuntu2004"
      ubuntu.vm.box_version = "3.2.6"

      ubuntu.vm.synced_folder ".", "/vagrant"

      ubuntu.vm.provision :shell, privileged: false,
        inline: "sh <(curl -sSfL https://nixos.org/nix/install) --daemon --nix-extra-conf-file /vagrant/nix.conf"

      ubuntu.vm.provision :shell, privileged: false,
        inline: "cd /vagrant && nix-shell --command switch-home"
    end

    # Ubuntu latest
    config.vm.define :ubuntu2010, autostart: false do |ubuntu|
      ubuntu.vm.box = "generic/ubuntu2010"
      ubuntu.vm.box_version = "3.2.6"

      ubuntu.vm.synced_folder ".", "/vagrant"

      ubuntu.vm.provision :shell, privileged: false,
        inline: "sh <(curl -ssfl https://nixos.org/nix/install) --daemon --nix-extra-conf-file /vagrant/nix.conf"

      ubuntu.vm.provision :shell, privileged: false,
        inline: "cd /vagrant && nix-shell --command switch-home"
    end

    # MacOS
    config.vm.define :bigsur, autostart: false do |bigsur|
        bigsur.vm.box = "andreiborisov/macos-bigsur-intel"
        bigsur.vm.box_version = "1.3.0"

        # bigsur.vm.synced_folder ".", "/Users/vagrant/nix-cfg", type: "rsync"

        # bigsur.vm.provision :shell, privileged: false,
        #   inline: "sh <(curl -sSfL https://nixos.org/nix/install) --daemon --darwin-use-unencrypted-nix-store-volume"

        # # Not required if logged in to UI
        # bigsur.vm.provision :shell, privileged: false, inline:
        #   "zsh -i -c 'nix-env -iA nixpkgs.gitMinimal'"

        # # Disable /nix spotlight indexing and drop default nix.conf (recreated by nix-darwin)
        # bigsur.vm.provision :shell, inline:
        #   "mdutil -i off /nix && rm /etc/nix/nix.conf"

        # bigsur.vm.provision :shell, privileged: false, inline:
        #   "zsh -i -c 'cd nix-cfg && nix-shell --command switch-darwin'"
      bigsur.vm.provider :vmware_desktop do |vmware|
        vmware.gui = true
      end
    end

    # Windows 10
    config.vm.define :windows, autostart: false do |windows|
      windows.vm.box = "StefanScherer/windows_10"
      windows.vm.box_version = "2021.04.14"

      windows.vm.provider :vmware_desktop do |vmware|
        vmware.gui = true
        vmware.vmx["memsize"] = "8192"
        vmware.vmx["numvcpus"] = "4"
        vmware.vmx["vhv.enable"] = "true"
      end
    end
end