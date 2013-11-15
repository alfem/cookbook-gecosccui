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

default['gecoscc-ui']['backend']['package'] = 'https://github.com/gecos-team/gecoscc-ui/archive/0.1.tar.gz'
default['gecoscc-ui']['backend']['version'] = '0.1'
default['gecoscc-ui']['backend']['virtual_prefix'] = '/opt/gecosccui-'
default['gecoscc-ui']['backend']['workers'] = 2
  default['gecoscc-ui']['backend']['firewall'] = 'lokkit'
