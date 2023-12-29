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
```

## instance
```bash
./gentoo-incus instance list
./gentoo-incus instance list --type vm
./gentoo-incus instance list --type container
./gentoo-incus instance list --keep-update
./gentoo-incus instance list --testing-all
./gentoo-incus instance list --testing
./gentoo-incus instance list --stable-all
./gentoo-incus instance list --stable

./gentoo-incus instance update --stable [ <stage3> <stage3> ]
./gentoo-incus instance update --stable-all [ <stage3> <stage3> ]
./gentoo-incus instance update --stable-all --all
./gentoo-incus instance update -p --type vm [ <stage3> <stage3> ]

./gentoo-incus instance create --type vm --stable --python all --python-single python3_11 --build-image <stage3>

./gentoo-incus instance copy --type vm --stable --all-python-targets --create [ name ]
```

## gtest

```bash
./gtest commits --overlay gentoo-zh --use-stable --python all --lua all --ruby all
```
