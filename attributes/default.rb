#
# Cookbook Name:: rngd-tools
# Attributes:: default
#

default['rng_tools']['device'] = '/dev/urandom' # Specific device to use if dynamic is false
default['rng_tools']['dynamic'] = false # Use 1st device from devices array
default['rng_tools']['devices'] = %w( /dev/hwrng /dev/hw_random /dev/hwrandom /dev/urandom )
default['rng_tools']['use_hwrng'] = false # Use hardware device if present in CPU

if node["platform_family"] == "rhel" and node["platform_version"].to_i < 6
  default['rng_tools']['package'] = "rng-utils"
else
  default['rng_tools']['package'] = "rng-tools"
end
