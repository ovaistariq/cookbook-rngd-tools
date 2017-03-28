module RndgTools
  module Helpers
    def hwrng?
      node['cpu']['0']['flags'].include?('rdrand')
    end

    def rng_device
      case node['rng_tools']['dynamic']
      when true
        node['rngd-tools']['devices'].each do |device|
          if ::File.chardev?(device)
            Chef::Log.info("Using #{node['rng_tools']['device']} as an entropy source")
            return device
          end
        end
      when false
        node['rngd-tools']['device']
      end
    end
  end
end

Chef::Recipe.send(:include, RndgTools::Helpers)
Chef::Resource.send(:include, RndgTools::Helpers)
