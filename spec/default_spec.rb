# encoding: utf-8
require 'chefspec'
require 'spec_helper'
require 'fauxhai'

describe 'mysql_config::mysqldb' do
  before do
    # Chef::Recipe.any_instance.stub(:data_bag).with('mysql').and_return(json)
    stub_data_bag('mysql').and_return(['password', 'mysql'])
    stub_data_bag_item('mysql', 'test').and_return({
      id: 'mysql',
      password: 'test'
    })
    stub_command("/usr/bin/test -f /data/mysql/mysql/user.frm").and_return(true)
  end
  #let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'centos', version: '6.6').converge(described_recipe) }
  cached(:mysql_config_test) do
    ChefSpec::SoloRunner.new(
      platform: 'centos',
      version: '6.6',
      step_into: 'mysql_service'
    ) do |node|
      node.set['mysql']['version'] = '5.5',
      node.set['mysql_config']['instance_name'] = 'test',
      node.set['mysql_config']['databag_name'] = 'mysql'
    end.converge('mysql_config::mysqldb')
  end
  # before do
  #  stub_command("cat /etc/rc.local | grep 'never > /sys/kernel/mm/transparent_hugepage/enabled'").and_return(true)  
  #end

  context 'compling the test recipe' do
    it 'creates mysql_service[test]' do
      expect(mysql_config_test).to create_mysql_service('test')
    end
  end

  context 'stepping into mysql_service[test] resource' do
    it 'installs package mysql-community-server' do
      expect(mysql_config_test).to install_package('test :create mysql-community-server')
        .with(package_name: 'mysql-community-server', version: nil)
    end

    it 'stop service [test :create mysqld]' do
      expect(mysql_config_test).to disable_service('test :create mysqld')
      expect(mysql_config_test).to stop_service('test :create mysqld')
    end

    it 'creates group[test :create mysql]' do
      expect(mysql_config_test).to create_group('test :create mysql')
    end

    it 'creates user[test :create mysql]' do
      expect(mysql_config_test).to create_user('test :create mysql')
    end

    it 'changes permissions on binlogs' do
      expect(mysql_config_test).to run_execute('chown -R mysql:mysql /logs/mysql/bin-logs')
    end

    it 'changes relay log permissions' do
      expect(mysql_config_test).to run_execute('chown -R mysql:mysql /logs/mysql/relay-logs')
    end

    it 'removes old innodb log files' do
      expect(mysql_config_test).to run_execute('rm /data/mysql/ib_logfile*')
    end

  end
end

describe 'mysql_config::datafiles' do
  before do
    # Chef::Recipe.any_instance.stub(:data_bag).with('mysql').and_return(json)
    stub_data_bag('mysql').and_return(['password', 'mysql'])
    stub_data_bag_item('mysql', 'test').and_return({
      id: 'mysql',
      password: 'test'
    })
    stub_command("/usr/bin/test -f /data/mysql/mysql/user.frm").and_return(true)
  end
   cached(:mysql_config_test) do
    ChefSpec::SoloRunner.new(
      platform: 'centos',
      version: '6.6',
      step_into: 'mysql_service'
    ) do |node|
      node.set['mysql']['version'] = '5.5',
      node.set['mysql_config']['instance_name'] = 'test',
      node.set['mysql_config']['databag_name'] = 'mysql'
    end.converge('mysql_config::mysqldb')
  end

  it 'creates /data/mysql directory' do
    expect(mysql_config_test).to create_directory('/data/mysql')
  end
end
