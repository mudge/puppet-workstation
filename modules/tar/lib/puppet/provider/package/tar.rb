require "puppet/provider/package"
require "tmpdir"

Puppet::Type.type(:package).provide(:tar, :parent => Puppet::Provider::Package) do
  desc "Package management using tarballs from the Internet."

  commands :curl    => "curl"
  commands :tar     => "tar"

  has_feature :installable

  def self.applications
    Dir["/Applications/*.app"].map { |app| File.basename(app, ".app") }
  end

  def self.instances
    applications.map { |a| new(:name => a, :ensure => :present, :provider => :tar) }
  end

  def query
    if File.directory?("/Applications/#{resource[:name]}.app")
      { :name => resource[:name], :ensure => :present, :provider => :tar }
    end
  end

  def install
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do

        # Download the tarball.
        curl("-o", resource[:name], "-L", resource[:source])

        # Extract the tarball.
        tar("-xvf", resource[:name])

        # Copy the named application to /Applications.
        app = Dir["*/#{resource[:name]}.app"].first

        FileUtils.cp_r(app, "/Applications")
      end
    end
  end
end
