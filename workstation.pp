$home = '/Users/mudge'

# Normal Mac applications.
package {
  'Google Chrome':
    ensure   => present,
    source   => 'https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg',
    provider => dmg;

  'Adium':
    ensure   => present,
    source   => 'http://download.adium.im/Adium_1.5.dmg',
    provider => dmg;

  'Spotify':
    ensure   => present,
    source   => 'http://download.spotify.com/Spotify.dmg',
    provider => dmg;

  'Skype':
    ensure   => present,
    source   => 'http://www.skype.com/go/getskype-macosx.dmg',
    provider => dmg;

  'Dropbox':
    ensure   => present,
    source   => 'https://www.dropbox.com/download?plat=mac',
    provider => dmg;

  'LaunchBar':
    ensure   => present,
    source   => 'http://www.obdev.at/downloads/LaunchBar/nightly/LaunchBar-5.2-nightly-907.dmg',
    provider => dmg;

  'MacVim':
    ensure   => present,
    source   => 'https://github.com/downloads/b4winckler/macvim/MacVim-snapshot-64.tbz',
    provider => tar;
}

# rbenv and ruby-build installation.
vcsrepo { "$home/.rbenv":
  ensure   => present,
  source   => 'git://github.com/sstephenson/rbenv.git',
  provider => git,
}

file { "$home/.rbenv/plugins":
  ensure  => directory,
  require => Vcsrepo["$home/.rbenv"],
}

vcsrepo { "$home/.rbenv/plugins/ruby-build":
  ensure   => present,
  source   => 'git://github.com/sstephenson/ruby-build.git',
  provider => git,
}

# Versions of Ruby.
package { '1.9.3-p125':
  ensure   => present,
  provider => ruby_build,
  require  => Vcsrepo["$home/.rbenv/plugins/ruby-build"],
}

# Homebrew installation
vcsrepo { '/usr/local':
  ensure   => present,
  source   => 'git://github.com/mxcl/homebrew.git',
  provider => git,
  force    => true,
}

# Homebrew packages.
package {
  'git':
    ensure   => present,
    provider => homebrew,
    require  => Vcsrepo['/usr/local'];

  'hub':
    ensure   => present,
    provider => homebrew,
    require  => Vcsrepo['/usr/local'];

}

# mvim command.
file { '/usr/local/bin/mvim':
  ensure  => present,
  mode    => '0755',
  source  => 'puppet:///modules/mvim/mvim',
  require => Vcsrepo['/usr/local'],
}

# Various dotfiles.
file {
  "$home/.vim":
    ensure => link,
    target => "$home/Dropbox/Projects/dotfiles/.vim";

  "$home/.vimrc":
    ensure => link,
    target => "$home/Dropbox/Projects/dotfiles/.vimrc";

  "$home/.gvimrc":
    ensure => link,
    target => "$home/Dropbox/Projects/dotfiles/.gvimrc";

  "$home/.zshrc":
    ensure => link,
    target => "$home/Dropbox/Projects/dotfiles/.zshrc";

  "$home/.gemrc":
    ensure => link,
    target => "$home/Dropbox/Projects/dotfiles/.gemrc";

  "$home/.gnupg":
    ensure => link,
    target => "$home/Dropbox/.gnupg";

  "$home/.ssh":
    ensure => link,
    target => "$home/Dropbox/.ssh";
}

