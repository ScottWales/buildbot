## \file    manifests/default.pp
#  \author  Scott Wales <scott.wales@unimelb.edu.au>
#  \brief
#
#  Copyright 2014 Scott Wales
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

class jenkins {
  $package  = 'jenkins'
  $service  = 'jenkins'
  $ajp_port = 8009

  yumrepo {'jenkins':
    baseurl  => 'http://pkg.jenkins-ci.org/redhat',
    gpgkey   => 'http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key',
    enabled  => '1',
    gpgcheck => '1',
  } ->
  package {$package:} ->
  service {$service:
    ensure  => running,
    enable  => true,
    restart => true,
    require => Class['java'],
  }

  apache::vhost {'jenkins':
    servername => '*',
    port       => '80',
    docroot    => '/var/www/jenkins',
    proxy_dest => "ajp://127.0.0.1:${ajp_port}",
    require    => Class['apache::mod::proxy_ajp'],
  }
}
