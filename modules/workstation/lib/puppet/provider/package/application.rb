require "puppet/provider/package"
require "tmpdir"

Puppet::Type.type(:package).provide(:application, :parent => Puppet::Provider::Package) do
  desc "Package management for Mac OS X Applications from the Internet."

  commands :curl => "curl"

  has_feature :installable

  def self.applications
    Dir["/Applications/*.app"].map { |app| File.basename(app, ".app") }
  end

  def self.instances
    applications.map { |application|
      new(:name => application, :ensure => :present, :provider => name)
    }
  end

  def query
    if File.directory?("/Applications/#{resource[:name]}.app")
      { :name => resource[:name], :ensure => :present, :provider => name }
    end
  end

  def install
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        download
        extract
        install_application
        cleanup
      end
    end
  end

  private

  def download
    curl("-o", resource[:name], "-L", resource[:source])
  end

  def install_application
  end

  def extract
  end

  def cleanup
  end
end
