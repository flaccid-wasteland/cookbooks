# Cookbook Name:: rest_connection
# Recipe:: install
#
# Copyright 2011-2012, Chris Fordham
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

# install rest_connection build/install deps
pkg_deps = value_for_platform(
  [ "centos", "redhat", "suse", "fedora" ] => {"default" => [ "libxml2", "libxml2-devel libxslt-devel"]},
  [ "ubuntu", "debian" ] => {"default" => [ "libxml2", "libxml2-dev", "libxslt1-dev"]},
  "archlinux" => {"default" => [ "libxml2", "libxslt"]}
)
pkg_deps.push('make')
pkg_deps.each { |pkg|
  p = package pkg do
    action :nothing
  end
  p.run_action(:install)
} unless ! pkg_deps

gem_package "i18n"
gem_package "rest_connection"