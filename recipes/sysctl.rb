#
# Cookbook Name:: mysql_config
# Recipe:: sysctl
#
# Copyright (c) 2015 gannett digital
#
#

include_recipe 'sysctl::default'

sysctl_param 'vm.swappiness' do
  value 0
end
