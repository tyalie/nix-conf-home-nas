{ config, pkgs, ... }:

{
  users.users.nas = {
    isNormalUser = true;
    extraGroups = [ "wheel" "users" ];
    packages = with pkgs; [
      neovim
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAERKazlCZnxLnhWTROFDyXoWWodOP0ReqPSgQMZvfv57Lu+fH1aGfC4kvNA7QuaKGS7I/tEBIWptBDppPw9JF4gsU5H1Np7EwhfdHEk2jYxxf0Asj7mO9YOiC6ftYDD1owXqYW2gNSDWRN9r7rPPvqLMBIV2VvUS8zu/m/joYcRjN0v2CA1pf8zBN0pIOzhTN7xRNra7jv+3nRNbDe+jXV49ey64cMyzcoRdFGURzAoJTbd7X4urHMbwmc/N8DTgce1vtTxsai6gYRFZYZAI/E9P1xV0/4x68fIz3NlQml5nEF04Z+ezGjz6yKADZ2ZToBsIAnpbAoKj0nBgWRmJtNuBtEwHxiL3HPtHptMDZSLcNrwHypWsLu1xQXBy74AIuZRFLcQuXMD9as7t9OrEdLtJfcSXA0NWrHiYdq1c/JWK1YVGCkVXQT80g5PyoNq98Bl9jHdLxBDRfzt9Gx6dDGqvpdBoqbgkwZJrUzlQOGxWGvt2gJZ6oPj1SV6CpRvvXJ+O6kNiPaBFUDNtiSMmQFr3G1CGmVJSFsikdJ+nuVstdKscP/x/rriAJ0+oxX3ftUbnreWy+rW1UeRMAa7PhfcrFG0z6GlVcP0tYmhmmJ2QwR3ZQYp/KV/twUZxiE/bLvCmLlfWxha6bXu2x9oOrOMe6Ut823mdA1TRE27cwsw== nas"
    ];
  };

  environment.variables = rec {
    EDITOR = "nvim";
  };
}
