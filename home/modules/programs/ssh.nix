{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
    controlPath = "/tmp/.ssh-%C";
    # extraConfig = ''
    #   Host github.com
    #     PKCS11Provider /usr/local/lib/opensc-pkcs11.so
    # '';
  };
}
