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
