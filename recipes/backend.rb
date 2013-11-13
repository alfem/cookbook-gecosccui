#
# Cookbook Name:: gecosccui
# Recipe:: backend
#
# Copyright 2013, Junta de Andalucia
# http://www.juntadeandalucia.es/
#
# All rights reserved - EUPL License V 1.1
# http://www.osor.eu/eupl
#

include_recipe "python"
include_recipe "build-essential"

package_name = node['gecoscc-ui']['backend']['package']
package_version = node['gecoscc-ui']['backend']['version']
virtualenv_prefix = node['gecoscc-ui']['backend']['virtual_prefix']
virtualenv_path = virtualenv_prefix + package_version

nginx_version = '1.4.3'
nginx_prefix = virtualenv_path 
nginx_sbin_path = virtualenv_path + '/bin/nginx'
nginx_conf = virtualenv_path + '/nginx/'
nginx_flags = %W[
                --prefix=#{nginx_prefix}
                --conf-path=#{nginx_conf}/nginx.conf
                --sbin-path=#{nginx_sbin_path}
              ]


node.set['nginx']['source']['url'] = "http://nginx.org/download/nginx-#{nginx_version}.tar.gz"
node.set['nginx']['source']['version'] = nginx_version
node.set['nginx']['source']['prefix'] = nginx_prefix
node.set['nginx']['source']['sbin_path'] = nginx_sbin_path
node.set['nginx']['version'] = nginx_version
node.set['nginx']['dir'] = nginx_conf
node.set['nginx']['prefix'] = '/opt/nginx/'
node.set['nginx']['install_method'] = 'source'
# node.default['nginx']['default_site_enabled'] = 
node.force_override['nginx']['source']['default_configure_flags'] = nginx_flags
node.force_override['nginx']['source']['configure_flags'] = nginx_flags

node.default['nginx']['init_style'] = 'init'

include_recipe "nginx::source"


# Add mongodb repository
yum_repository "10gen" do
    description "10gen RPM Repository"
    url "http://downloads-distro.mongodb.org/repo/redhat/os/#{node['kernel']['machine']  =~ /x86_64/ ? 'x86_64' : 'i686'}"
    action :add
end

package "mongo-10gen-server" do
    action :install
end

package "mongo-10gen" do
    action :install
end

python_virtualenv virtualenv_path do
    action :create
end

python_pip "https://github.com/surfly/gevent/releases/download/1.0rc3/gevent-1.0rc3.tar.gz" do
    virtualenv virtualenv_path
end

python_pip package_name do
    virtualenv virtualenv_path
    version package_version
end

python_pip 'supervisord' do
    virtualenv virtualenv_path
end


template "gecoscc-ini" do
    source "gecoscc.ini"
    path virtualenv_path + '/gecoscc.ini'
end

template "gecoscc-nginx" do
    source "gecoscc.nginx.conf"
    path node['nginx']['dir'] + '/conf.d/gecoscc.conf'
end

template "gecoscc-supervisord" do
    source "gecoscc.supervisord.conf"
    path virtualenv_path + '/supervisord.conf'
end
