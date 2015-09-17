#
# Cookbook Name:: rngd-tools
# Attributes:: default
#

default['rng_tools']['device'] = "/dev/urandom"

if node["platform_family"] == "rhel" and node["platform_version"].to_i < 6
  default['rng_tools']['package'] = "rng-utils"
else
  default['rng_tools']['package'] = "rng-tools"
end
