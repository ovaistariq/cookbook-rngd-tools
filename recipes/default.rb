#
# Cookbook Name:: rngd-tools
# Recipe:: default
#
# Copyright 2011, Joshua Timberman
# Copyright 2015, Ovais Tariq
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package node['rng_tools']['package']

case node['platform_family']
when "fedora", "rhel"
  template "/etc/sysconfig/rngd" do
    source "rngd.sysconfig.erb"
    mode 0644
    owner "root"
    group "root"
    notifies :restart, "service[rng-tools]"
  end

  template "/etc/systemd/system/rngd.service" do
    source "systemd/rngd.service.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :run, "bash[reload-systemd-daemon]", :immediately
    notifies :restart, "service[rng-tools]", :immediately
    only_if { node["platform_version"].to_f >= 7.0 }
    only_if { node["platform"] != "amazon" }
  end

  template "/etc/init.d/rngd" do
    source "sysvinit/rngd.service.erb"
    owner "root"
    group "root"
    mode "0755"
    notifies :restart, "service[rng-tools]"
    only_if { node["platform_version"].to_f < 6.0 }
    only_if { node["platform"] != "amazon" }
  end
else
  template "/etc/default/rng-tools" do
    source "rng-tools.default.erb"
    mode 0644
    owner "root"
    group "root"
    notifies :restart, "service[rng-tools]"
  end
end

service "rng-tools" do
  case node['platform_family']
  when "rhel", "fedora"
    service_name "rngd"
    supports :status => :true, :restart => :true, :reload => :true
  else
    supports :restart => true
  end
  action [:enable, :start]
end

bash "reload-systemd-daemon" do
  user "root"
  code <<-EOH
    systemctl daemon-reload
  EOH
  action :nothing
end
