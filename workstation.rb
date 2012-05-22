#!/usr/bin/env puppet apply --no-report --modulepath=modules

define :brew do
  package @name,
    :ensure   => :present,
    :provider => :homebrew,
    :require  => "Vcsrepo[/usr/local]"
end

define :ruby do
  package @name,
    :ensure   => :present,
    :provider => :ruby_build,
    :require  => "Vcsrepo[#{ENV["HOME"]}/.rbenv/plugins/ruby-build]"
end

define :dotfile do
  file "#{ENV["HOME"]}/#{@name}",
    :ensure   => :link,
    :target => "#{ENV["HOME"]}/Dropbox/Projects/dotfiles/#{@name}"
end

node "default" do
  if ENV["USER"] == "root"
    file "/usr/local",
      :ensure => :directory,
      :group  => "admin",
      :mode   => "0775"

    package "VirtualBox",
      :ensure   => :present,
      :source   => "http://download.virtualbox.org/virtualbox/4.1.14/VirtualBox-4.1.14-77440-OSX.dmg",
      :provider => :dmginstaller
  else
    {
      "Google Chrome"    => "https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg",
      "Adium"            => "http://download.adium.im/Adium_1.5.dmg",
      "Spotify"          => "http://download.spotify.com/Spotify.dmg",
      "Skype"            => "http://www.skype.com/go/getskype-macosx.dmg",
      "Dropbox"          => "https://www.dropbox.com/download?plat=mac",
      "LaunchBar"        => "http://www.obdev.at/downloads/launchbar/LaunchBar-5.2.dmg",
      "PS3 Media Server" => "http://ps3mediaserver.googlecode.com/files/pms-macosx-1.52.1.dmg",
      "Transmission"     => "http://download.transmissionbt.com/files/Transmission-2.51.dmg"
    }.each do |name, source|
      package name,
        :ensure   => :present,
        :source   => source,
        :provider => :dmg
    end

    package "MacVim",
      :ensure   => :present,
      :source   => "https://github.com/downloads/b4winckler/macvim/MacVim-snapshot-64.tbz",
      :provider => :archive

    package "Notational Velocity",
      :ensure   => :present,
      :source   => "http://notational.net/NotationalVelocity.zip",
      :provider => :archive

    package "Postgres",
      :ensure   => :present,
      :source   => "http://postgres-app.s3.amazonaws.com/Postgres-for-Mac-Beta-4.zip",
      :provider => :archive

    vcsrepo "#{ENV["HOME"]}/.rbenv",
      :ensure   => :present,
      :source   => "git://github.com/sstephenson/rbenv.git",
      :provider => :git

    file "#{ENV["HOME"]}/.rbenv/plugins",
      :ensure => :directory,
      :require => "Vcsrepo[#{ENV["HOME"]}/.rbenv]"

    vcsrepo "#{ENV["HOME"]}/.rbenv/plugins/ruby-build",
      :ensure   => :present,
      :source   => "git://github.com/sstephenson/ruby-build.git",
      :provider => :git

    ruby "1.9.3-p125"

    vcsrepo "/usr/local",
      :ensure   => :present,
      :source   => "git://github.com/mxcl/homebrew.git",
      :provider => :git,
      :force    => true

    brew %w[git hub gnupg tree ack mercurial]

    # re2 is a HEAD-only package.
    package "re2",
      :ensure => :head,
      :provider => :homebrew,
      :require  => "Vcsrepo[/usr/local]"

    file "/usr/local/bin/mvim",
      :ensure  => :present,
      :mode    => "0755",
      :source  => "puppet:///modules/mvim/mvim",
      :require => "Vcsrepo[/usr/local]"

    file "/usr/local/bin/vim",
      :ensure => :link,
      :target => "/usr/local/bin/mvim"

    dotfile %w[.vim .vimrc .gvimrc .zshrc .gemrc .bundle]

    %w[.gnupg .ssh].each do |dotfile|
      file "#{ENV["HOME"]}/#{dotfile}",
        :ensure   => :link,
        :target => "#{ENV["HOME"]}/Dropbox/#{dotfile}"
    end
  end
end
