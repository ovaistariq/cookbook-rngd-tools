name             "rngd-tools"
maintainer       "Ovais Tariq"
maintainer_email "me@ovaistariq.net"
license          "Apache 2.0"
description      "Installs/Configures rng-tools"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.3.0"

%w{ centos fedora amazon redhat debian ubuntu }.each do |os|
  supports os
end
