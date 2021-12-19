{ self, nixpkgs, home, flakebox, agenix, ... }@inputs:
{
  nixos = flakebox.lib.vagrantNixosConfig {
    modules = [
      {
        imports = [
          home.nixosModule
          agenix.nixosModules.age
        ];

        home-manager.useGlobalPkgs = false;
        home-manager.useUserPackages = false;
        home-manager.backupFileExtension = "backup";

        home-manager.extraSpecialArgs = { inherit inputs; };

        home-manager.users.vagrant = import ../../home/configurations/peteresselius;
      }
      # ({ pkgs, ... }: {
      #   services = {
      #     kibana = {
      #       enable = true;
      #       package = pkgs.kibana7;
      #     };
      #     elasticsearch = {
      #       enable = true;
      #       package = pkgs.elasticsearch7;
      #     };
      #     journalbeat = {
      #       enable = true;
      #       package = pkgs.journalbeat7;
      #       extraConfig = ''
      #         output.elasticsearch:
      #           hosts: [ "http://localhost:9200" ]
      #       '';
      #     };
      #     logstash = {
      #       enable = true;
      #       package = pkgs.logstash7;
      #       outputConfig = ''
      #         elasticsearch {
      #           hosts => [ "http://localhost:9200" ]
      #         }
      #       '';
      #     };
      #     metricbeat = {
      #       enable = true;
      #       package = pkgs.metricbeat7;
      #       modules.system = {
      #         metricsets = [ "cpu" "load" "memory" "network" "process" "process_summary" "uptime" "socket_summary" ];
      #         enabled = true;
      #         period = "5s";
      #         processes = [ ".*" ];
      #         cpu.metrics = [ "percentages" "normalized_percentages" ];
      #         core.metrics = [ "percentages" ];
      #       };
      #       settings = {
      #         output.elasticsearch = {
      #           hosts = [ "127.0.0.1:9200" ];
      #         };
      #       };
      #     };

      #   };
      # })
    ] ++ import ../modules;
  };
}

