# Puppet-Workstation

This is an attempt to use Puppet to manage applications and configuration on my
personal laptop.

As I use a Mac, applications mostly come in the form of disk images from the
Internet (files ending in `.dmg`) or in some sort of archive (e.g. [MacVim][]
which comes in a `.tgz`). Development tools (such as git) are installed via
[Homebrew][] and Ruby is installed via [rbenv][] and [ruby-build][].

To accommodate all of the above, I have written a few Puppet package providers:

* `dmg`: To download disk images from a URL and then extract specific
  applications from them into `/Applications`;
* `tar`: To download tarballs from a URL and then extract specific applications
  from them into `/Applications`;
* `homebrew`: To install packages via Homebrew;
* `ruby_build`: To install versions of Ruby through ruby-build.

I use the excellent [vcsrepo][] resource type via a git submodule to manage the
installation of Homebrew, rbenv and ruby-build (as they are all just git
repositories).

This is very experimental at this point though I am using it personally. If you
would like to try it out, you will need to clone this repo and pull in the
`vcsrepo` git submodule like so:

```console
$ git clone https://github.com/mudge/puppet-workstation.git
$ cd puppet-workstation
$ git submodule init
$ git submodule update
```

And then you can run it with:

```console
$ ./workstation.rb
```

To perform the necessary one-time setup as root, you can simply do:

```console
$ sudo ./workstation.rb
```

  [MacVim]: http://code.google.com/p/macvim/
  [Homebrew]: http://mxcl.github.com/homebrew/
  [rbenv]: https://github.com/sstephenson/rbenv
  [ruby-build]: https://github.com/sstephenson/ruby-build
  [vcsrepo]: https://github.com/puppetlabs/puppet-vcsrepo
