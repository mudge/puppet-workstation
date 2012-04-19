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
  else
    {
      "Google Chrome" => "https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg",
      "Adium"         => "http://download.adium.im/Adium_1.5.dmg",
      "Spotify"       => "http://download.spotify.com/Spotify.dmg",
      "Skype"         => "http://www.skype.com/go/getskype-macosx.dmg",
      "Dropbox"       => "https://www.dropbox.com/download?plat=mac",
      "LaunchBar"     => "http://www.obdev.at/downloads/LaunchBar/nightly/LaunchBar-5.2-nightly-907.dmg"
    }.each do |name, source|
      package name,
        :ensure   => :present,
        :source   => source,
        :provider => :dmg
    end

    package "MacVim",
      :ensure   => :present,
      :source   => "https://github.com/downloads/b4winckler/macvim/MacVim-snapshot-64.tbz",
      :provider => :tar

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

    brew %w[git hub gnupg]

    file "/usr/local/bin/mvim",
      :ensure  => :present,
      :mode    => "0755",
      :source  => "puppet:///modules/mvim/mvim",
      :require => "Vcsrepo[/usr/local]"

    file ["/usr/local/bin/vim", "/usr/local/bin/gvim"],
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
