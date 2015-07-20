#
# Cookbook Name:: mysql_config
# Recipe:: limits
#
# Copyright (c) 2015 gannett digital
#
#

limits_config 'system limits' do
  limits [
    { domain: '*', type: 'hard', item: 'nofile', value: '65536' },
    { domain: '*', type: 'soft', item: 'nofile', value: '65536' },
    { domain: '*', type: 'hard', item: 'nproc', value: '65536' },
    { domain: '*', type: 'soft', item: 'nproc', value: '65536' }
  ]
  use_system true
end