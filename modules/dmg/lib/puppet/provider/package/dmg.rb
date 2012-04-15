require "puppet/provider/package"
require "tmpdir"

Puppet::Type.type(:package).provide(:dmg, :parent => Puppet::Provider::Package) do
  desc "Package management using Disk Images from the Internet."

  commands :hdiutil => "hdiutil"
  commands :curl    => "curl"

  has_feature :installable, :uninstallable

  def self.applications
    Dir["/Applications/*.app"].map { |app| File.basename(app, ".app") }
  end

  def self.instances
    applications.map { |a| new(:name => a, :ensure => :present, :provider => :dmg) }
  end

  def query
    if File.directory?("/Applications/#{resource[:name]}.app")
      { :name => resource[:name], :ensure => :present, :provider => :dmg }
    end
  end

  def install
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        dmg = "#{resource[:name]}.dmg"

        # Download the disk image.
        curl("-o", dmg, "-L", resource[:source])

        # Mount it.
        hdiutil(:attach, dmg, "-nobrowse", "-mountpoint", "mount")

        # Copy the named application to /Applications.
        FileUtils.cp_r("mount/#{resource[:name]}.app", "/Applications")

        # Unmount the image.
        hdiutil(:detach, "mount")
      end
    end
  end

  def uninstall
    FileUtils.remove_entry_secure("/Applications/#{resource[:name]}.app")
  end
end
