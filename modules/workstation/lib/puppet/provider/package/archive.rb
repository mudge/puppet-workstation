require "puppet/provider/package"
require "tmpdir"

Puppet::Type.type(:package).provide(:archive, :parent => :application) do
  desc "Package management using archives from the Internet."

  commands :tar => "tar"

  private

  def extract
    tar("-xvf", resource[:name])
  end

  def install_application
    app = Dir["{,*/}#{resource[:name]}.app"].first
    FileUtils.cp_r(app, "/Applications")
  end
end
