{ ... }: {
  age.identityPaths = [ "/home/samn/.ssh/samn" "/home/samn/.ssh/pavilion" ];

  age.secrets."passwords/users/samn".file = ../secrets/passwords/users/samn.age;
  age.secrets."passwords/email/sam_at_samnystrom.dev" = {
    file = ../secrets/passwords/email/sam_at_samnystrom.dev.age;
    owner = "samn";
    mode = "400";
  };
  age.secrets."networks".file = ../secrets/networks.age;
}
