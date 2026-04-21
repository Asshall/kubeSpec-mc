{ lib, ... }:
{
  # Where should the generated manifests be stored?
  nixidy.target.repository = "https://github.com/Asshall/kubernix-mc";
  nixidy.target.branch = "main";
  nixidy.target.rootPath = "./manifests/dev";
  applications.traefik = {
    namespace = "traefik";

    helm.releases.traefik = {

      chart = lib.helm.downloadHelmChart {

        chart = "traefik";
        repo = "https://traefik.github.io/charts";
        version = "v39.0.6";
        chartHash = "sha256-drSIM1FsWRTHm2rLO8ceexg8HisKtyzwrIj+LZ+Gbo8=";
      };
      values = {
        ingressRoute = {
          dashboard = {
            enabled = true;
            matchRule = "Host(`dashboard.localhost`)";
            entryPoints = [ "web" ];
          };
          providers = {
            kubernetesGateway = {
              enabled = true;
            };
          };
          gateway = {
            listeners = {
              web = {
                namespacePolicy = {
                  from = "All";
                };
              };
            };
          };
        };
      };
    };

    # Patch Helm output with nixidy
    #resources.deployments.traefik.spec.replicas = lib.mkForce 5;
  };
}
