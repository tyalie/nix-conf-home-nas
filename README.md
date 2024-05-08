# NixOS configuration for my home nas

This is my configuration for my NAS (network attached storage system) that I'm
using for my home.

As of time of writing, I'm running this as a virtual machine, using another
Linux for the host. With this I can easily "reboot" the NAS after configuration
changes, without troubling myself with the possibility of loosing contact to it.
(similar to Intel vPro). All relevant hardware is accessible by the NixOS using
PCIe passthrough (except the network).

## Hardware

- AsRock N100M board
- SATA extension card
- M.2 NVMe boot drive
- slots for 8 SATA drives, but currently:
  - 2x 2TB SSD for data
  - 1x 12TB HDD for backup

## Setup

There are a few things in my NAS, I did not bother to configure declaratively
using NixOS - especially when it only influences the NAS user and is for my own
comfort.

### GPG keys

In order to sign the commits, I need git to have access to my gpg keys. As I'm
using gpg-agent forwarding to expose access to the private keys, the process is
a bit different, then what one would normally do here. So that I don't forget it
again, I'll document it here.

Most configuration steps have already been taken in the declarative NixOS
configuration here.

```
# 1. copy public key database (or export/import)
(host)$ scp .gnupg/pubring.kbx nas:~/.gnupg/

# 2. list keys
(nixos)$ gpg --list-keys

# 3. trust the relevant key
(nixos)$ gpg --edit-key <KEY-ID>
> trust  # choose the level

# 4. make sure gpg-agent isn't running
(nixos)$ lsof /run/user/1000/gnupg/S.gpg-agent
# should return nothing

# 5. enable usage of agent for gpg
(nixos)$ echo use-agent >> ~/.gnupg/gpg.conf

# 6. try it out (should return your keys)
(nixos)$ gpg -K
```


