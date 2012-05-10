require "puppet/provider/package"

Puppet::Type.type(:package).provide(:homebrew, :parent => Puppet::Provider::Package) do
  desc "Package management using Homebrew."

  commands :brew => "brew"

  has_feature :installable, :uninstallable, :versionable

  def self.installed
    brew(:list, "-v").split("\n").map { |line| line.split }
  end

  def self.instances
    installed.map { |name, version|
      ensure_value = if version == "HEAD"
        :head
      else
        :present
      end

      new(:name => name, :ensure => ensure_value, :provider => :homebrew)
    }
  end

  def install
    if resource[:ensure] == :head
      brew(:install, "--HEAD", resource[:name])
    else
      brew(:install, resource[:name])
    end
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

