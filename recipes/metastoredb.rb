opts = data_bag_item('mysql', 'datalake_mysql_root_pw')
hiveopts = data_bag_item('mysql','datalake_mysql_hive_pw')

mysql_connection_info = {
  :host => 'localhost',
  :username => 'root',
  :password => opts['password'],
  :socket => '/tmp/mysqld.sock'
}

cookbook_file '/tmp/hive-schema-0.13.0.mysql.sql' do
  source 'hive-schema-0.13.0.mysql.sql'
  owner 'root'
  mode '0644'
  action :create
end

bash 'source metastore' do
  user 'root'
  code "mysql -uroot -p#{opts['password']} -S /tmp/mysqld.sock -e 'create database metastore;use metastore;source /tmp/hive-schema-0.13.0.mysql.sql;'"
  not_if "mysql -uroot -p#{opts['password']} -S /tmp/mysqld.sock -e 'show databases' | grep metastore"
  action :run
end

mysql_database_user 'hiveuser' do
  connection mysql_connection_info
  database_name 'metastore'
  host '10.84.%'
  password hiveopts['password']
  privileges [:select, :update, :insert, :delete]
  action :grant
end