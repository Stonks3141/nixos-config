let
  pavilion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTj/D8u4STdw//BI7oMYvip8dzFobPcCtIR5jS9Q/J/";
  hosts = [ pavilion ];
  samn = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDfF8ksdV6XMXD7fbvIDSovEdo5CWt2Yy8I+UiylCQJ";
  users = [ samn ];
in
{
  "secrets/passwords/users/samn.age".publicKeys = hosts ++ [ samn ];
  "secrets/passwords/email/samuel.l.nystrom_at_gmail.com.age".publicKeys = hosts ++ [ samn ];
  "secrets/networks.age".publicKeys = hosts ++ users;
  "secrets/wireguard/pavilion.key.age".publicKeys = [ pavilion ] ++ users;
}
