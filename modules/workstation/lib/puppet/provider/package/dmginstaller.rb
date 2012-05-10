require "puppet/provider/package"
require "tmpdir"

Puppet::Type.type(:package).provide(:dmginstaller, :parent => :dmg) do
  desc "Package management using Disk Images from the Internet."

  commands :installer => "installer"

  def install_application
    Dir['mount/*.{m,}pkg'].each do |package|
      installer("-package", package, "-target", "/")
    end
  end
end

