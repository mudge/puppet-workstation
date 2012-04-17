require "puppet/provider/package"
require "fileutils"

Puppet::Type.type(:package).provide(:ruby_build, :parent => Puppet::Provider::Package) do
  desc "Package management using ruby-build."

  commands :rbenv => "rbenv"

  has_feature :installable, :uninstallable

  def self.installed
    rbenv(:versions).split("\n").map { |v| v.split[1] }
  end

  def self.instances
    installed.map { |a| new(:name => a, :ensure => :present, :provider => :ruby_build) }
  end

  def install
    rbenv(:install, resource[:name])
  end

  def query
    if self.class.installed.include?(resource[:name])
      { :name => resource[:name], :ensure => :present, :provider => :ruby_build }
    end
  end

  def uninstall
    installation = "#{ENV['HOME']}/.rbenv/versions/#{resource[:name]}"
    if File.directory?(installation)
      FileUtils.remove_entry_secure(installation)
    end
  end
end

