# my gentoo incus script

Based on this wiki, trying to write my incus script.
The main purpose of this repository is to try to automate my work.

https://wiki.gentoo.org/wiki/User:Juippis/The_ultimate_testing_system_with_lxd#Examples
https://github.com/juippis/my-gentoo-lxd-scripts.git

# usage

## image
```bash
./gentoo-incus image list
./gentoo-incus image list --type vm
./gentoo-incus image list --type container

./gentoo-incus image update [ <stage3> <stage3> ]
./gentoo-incus image update --type vm [ <stage3> <stage3> ]
./gentoo-incus image update -p --type vm [ <stage3> <stage3> ]

./gentoo-incus image build --type vm [ <stage3> <stage3> ]
./gentoo-incus image build --type vm --all
./gentoo-incus image build -p --all
```

## instance
```bash
./gentoo-incus list
./gentoo-incus list --type vm
./gentoo-incus list --type container
./gentoo-incus list --keep-update
./gentoo-incus list --testing-all
./gentoo-incus list --testing
./gentoo-incus list --stable-all
./gentoo-incus list --stable

./gentoo-incus update [ <stage3> <stage3> ]
./gentoo-incus update -p [ <stage3> <stage3> ]

./gentoo-incus create --type vm --stable --python all --python-single python3_11 --build-image --sync --update --depclean <stage3>

./gentoo-incus launch --type vm --stable --python all --python-single python3_11 --build-image --sync --update --depclean <stage3>

./gentoo-incus copy --stable --all-python-targets --sync --update [ name ]
```

## gtest

```bash
./gtest commits --overlay gentoo-zh --use-stable --python all --lua all --ruby all
```
