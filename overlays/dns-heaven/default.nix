{ src, buildGoModule }:

buildGoModule {
  pname = "dns-heaven";
  version = "v1.1.0";

  inherit src;

  vendorSha256 = "sha256-h0mbSX9spI61iC4JZpTuY52PZS648pXVVBXwi98hSis=";
}
