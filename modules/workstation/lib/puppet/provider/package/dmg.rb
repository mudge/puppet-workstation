require "puppet/provider/package"
require "tmpdir"

Puppet::Type.type(:package).provide(:dmg, :parent => :application) do
  desc "Package management using Disk Images from the Internet."

  commands :hdiutil => "hdiutil", :yes => "yes"

  private

  def dmg
    "image.dmg"
  end

  def download
    curl("-o", dmg, "-L", resource[:source])
  end

  def extract
    execute("yes | hdiutil attach #{dmg} -nobrowse -mountpoint mount")
  end

  def install_application
    FileUtils.cp_r("mount/#{resource[:name]}.app", "/Applications")
  end

  def cleanup
    hdiutil(:detach, "mount")
  end
end
