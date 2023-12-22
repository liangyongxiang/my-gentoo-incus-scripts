# my gentoo incus script

Based on this wiki, trying to write my incus script.
The main purpose of this repository is to try to automate my work.

https://wiki.gentoo.org/wiki/User:Juippis/The_ultimate_testing_system_with_lxd#Examples
https://github.com/juippis/my-gentoo-lxd-scripts.git

## About the template for incus/images:

- Modifications to https://github.com/lxc/lxc-ci/blob/main/images/gentoo.yaml
- Use separated files: openrc/systemd, vm/container
- Clean up all non-essential steps in the yaml.
  - If it doesn't affect startup, deal with it after startup.
