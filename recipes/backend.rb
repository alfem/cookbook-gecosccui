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
workers = node['gecoscc-ui']['backend']['workers']
firewall_type =  node['gecoscc-ui']['backend']['firewall']

nginx_version = '1.4.3'
nginx_prefix = '/opt/nginx'
nginx_sbin_path = nginx_prefix + '/bin/nginx'
nginx_conf = nginx_prefix + '/etc'
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
node.set['nginx']['log_dir'] = nginx_prefix + '/logs'
node.set['nginx']['prefix'] = nginx_prefix
node.set['nginx']['install_method'] = 'source'
node.default['nginx']['default_site_enabled'] = false
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

service "mongod" do
    action [:enable, :start]
end

# Create the gecoscc virtualenv
python_virtualenv virtualenv_path do
    action :create
end


# The gevent required version by pyramid_sockjs
python_pip "https://pypi.python.org/packages/source/g/gevent/gevent-1.0.tar.gz" do
    virtualenv virtualenv_path
end

python_pip package_name do
    virtualenv virtualenv_path
    version package_version
    notifies :restart, 'service[supervisord]', :delayed
end

python_pip 'supervisor' do
    virtualenv virtualenv_path
end

directory virtualenv_path + '/supervisor'
directory virtualenv_path + '/supervisor/log'
directory virtualenv_path + '/supervisor/run'

service_factory "supervisord" do
    service_desc "GecosCC UI Supervisor"
    exec virtualenv_path + '/bin/supervisord'
    exec_args ' -n -c ' + virtualenv_path + '/supervisord.conf'
    run_user "root"
    run_group "root"
    action [:create, :enable]
end

service "nginx" do
    action :enable
end

template "gecoscc-ini" do
    source "gecoscc.ini.erb"
    path virtualenv_path + '/gecoscc.ini'
    notifies :restart, 'service[supervisord]', :delayed
end

template "gecoscc-nginx" do
    source "gecoscc.nginx.conf.erb"
    path node['nginx']['dir'] + '/sites-available/gecoscc.conf'
    notifies :reload, 'service[nginx]', :delayed
    variables({
        :workers_number => Array(0..workers-1),
        :hostname => node['hostname']
    })
end

template "gecoscc-supervisord" do
    source "gecoscc.supervisord.conf.erb"
    path virtualenv_path + '/supervisord.conf'
    variables({
        :virtualenv_path => virtualenv_path,
        :workers => workers,
    })
    notifies :restart, 'service[supervisord]'
end

nginx_site "gecoscc.conf" do
    action :enable
    notifies :reload, 'service[nginx]', :delayed
end


bash "lokkit" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    lokkit -s http
    lokkit -s https
  EOH
  only_if { firewall_type == 'lokkit' }
end
