require "puppet/provider/package"

Puppet::Type.type(:package).provide(:homebrew, :parent => Puppet::Provider::Package) do
  desc "Package management using Homebrew."

  commands :brew => "brew"

  has_feature :installable, :uninstallable

  def self.installed
    brew(:list, "-v").split("\n").map { |a| a.split.first }
  end

  def self.instances
    installed.map { |a| new(:name => a, :ensure => :present, :provider => :homebrew) }
  end

  def install
    brew(:install, resource[:name])
  end

  def query
    unless brew(:list, "-v", resource[:name]).strip.empty?
      { :name => resource[:name], :ensure => :present, :provider => :homebrew }
    end
  end

  def uninstall
    brew(:remove, resource[:name])
  end
end

