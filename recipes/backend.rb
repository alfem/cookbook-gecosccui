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


node.override['nginx']['source']['url'] = 'http://nginx.org/download/nginx-1.4.3.tar.gz'
node.override['nginx']['source']['version'] = '1.4.3'
node.override['nginx']['version'] = '1.4.3'
node.override['nginx']['dir'] = '/opt/nginx/etc/'
node.override['nginx']['prefix'] = '/opt/nginx/'
node.override['nginx']['install_method'] = 'source'
# node.default['nginx']['default_site_enabled'] = 
node.override['nginx']['source']['default_configure_flags'] = %W[
                                                          --prefix=#{node['nginx']['source']['prefix']}
                                                          --conf-path=#{node['nginx']['dir']}/nginx.conf
                                                          --sbin-path=#{node['nginx']['source']['sbin_path']}
                                                        ]


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

package "openssl" do
    action :install
end

package "openssl-devel" do
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
