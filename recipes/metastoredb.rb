opts = data_bag_item('mysql', 'datalake_mysql_root_pw')
hiveopts = data_bag_item('mysql','datalake_mysql_hive_pw')

mysql_connection_info = {
  :host => 'localhost',
  :username => 'root',
  :password => opts['password'],
  :socket => '/tmp/mysqld.sock'
}

mysql_database 'metastore' do
  connection mysql_connection_info
  action :create
end

mysql_database_user 'hiveuser' do
  connection mysql_connection_info
  database_name 'metastore'
  host '10.84.%'
  password hiveopts['password']
  action :grant
end

cookbook_file '/tmp/hive-schema-0.13.0.mysql.sql' do
  source 'hive-schema-0.13.0.mysql.sql'
  owner 'root'
  mode '0644'
  action :create
end

mysql_database 'metastore' do
  connection mysql_connection_info
  sql 'source /tmp/hive-schema-0.13.0.mysql.sql;'
end

 execute 'import_schema' do
   command "mysql -uroot -p#{opts['password']} -S /tmp/mysqld.sock metastore < /tmp/hive-schema-0.13.0.mysql.sql;"
   action :run
 end

