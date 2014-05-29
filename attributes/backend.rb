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

default['gecoscc-ui']['backend']['version'] = '0.5.2'
default['gecoscc-ui']['backend']['package'] = 'https://github.com/gecos-team/gecoscc-ui/archive/' << default['gecoscc-ui']['backend']['version'] << '.tar.gz'
default['gecoscc-ui']['backend']['virtual_prefix'] = '/opt/gecosccui-'
default['gecoscc-ui']['backend']['workers'] = 2
default['gecoscc-ui']['backend']['firewall'] = 'lokkit'
default['gecoscc-ui']['chef-server']['url'] = 'https://localhost/'
default['gecoscc-ui']['mongodb']['url'] = 'mongodb://localhost:27017/gecoscc'
