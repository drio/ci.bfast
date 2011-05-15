maintainer       "David Rio Deiros"
maintainer_email "driodeiros@gmail.com"
license          "Apache 2.0"
description      "Installs bzlib"
version          "0.1.1"

recipe "bzlib", "Installs bzlib development package"

%w{ centos redhat suse fedora ubuntu debian }.each do |os|
  supports os
end
