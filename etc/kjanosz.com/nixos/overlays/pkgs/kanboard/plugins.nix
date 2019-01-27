{ fetchFromGitHub, pkgs }:

{
  beanstalk = {
    src = fetchFromGitHub {
      owner = "kanboard";
      repo = "plugin-beanstalk";
      rev = "fb9dbf2afc9ddc3e3ce1935b7629d5ec7a14c8b6";
      sha256 = "0gsmwk6f0hr3xkp5akaj019qkckjrqlhmw5spz1rq0qk04ncmc43";
    };
    
    dest = "Beanstalk";

    unit = kanboard: {
      description = "Kanboard worker to interact with Beanstalk";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      requires = [ "beanstalkd.service" ];
      path = [ kanboard pkgs.php ];
      script = ''
        cd ${kanboard}
        ./cli worker
      '';
    };
  };

  nebula = {
    src = fetchFromGitHub {
      owner = "kenlog";
      repo = "Nebula";
      rev = "0cf501830b0237716abfe59e6ce1b5cc1ef11e49";
      sha256 = "0d36sv7jv1j4xrwmzk1hjw3y2r4gn9xk51ay6dq6vfy7fmizmlc1";
    };
    
    dest = "Nebula";
  };
}
