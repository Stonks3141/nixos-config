{ ... }: {
  age.identityPaths = [ "/home/samn/.ssh/samn" "/home/samn/.ssh/pavilion" ];

  age.secrets."passwords/users/samn".file = ../secrets/passwords/users/samn.age;
  age.secrets."passwords/email/samuel.l.nystrom_at_gmail.com" = {
    file = ../secrets/passwords/email/samuel.l.nystrom_at_gmail.com.age;
    owner = "samn";
    mode = "400";
  };
  age.secrets."networks".file = ../secrets/networks.age;
  age.secrets."wireguard/pavilion.key".file = ../secrets/wireguard/pavilion.key.age;
}
