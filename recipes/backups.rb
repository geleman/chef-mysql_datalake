include_recipe 'cron::default'
opts = data_bag_item('mysql', 'datalake_mysql_root_pw')

directory '/data/dumps' do
  owner 'mysql'
  group 'mysql'
  mode '0750'
  recursive true
  action :create
end

bash 'create backup user' do
  user 'mysql'
  code <<-EOF
  mysql -uroot -p#{opts['password']} -S /tmp/mysqld.sock -e "create user 'backup'@'localhost' identified by 'backup';"
  mysql -uroot -p#{opts['password']} -S /tmp/mysqld.sock -e "grant usage, select, reload, lock tables, show view, trigger on *.* to 'backup'@'localhost';"
  mysql -uroot -p#{opts['password']} -S /tmp/mysqld.sock -e "flush privileges;"
  EOF
  not_if "mysql -uroot -p#{opts['password']} -S /tmp/mysqld.sock -e 'select user, host from mysql.user' | grep backup"
  action :run
end

cookbook_file '/var/lib/mysql/backup.sh' do
  source 'backup.sh'
  owner 'mysql'
  mode '750'
  action :create
end

cron_d 'mysql_backup' do
  minute 5
  hour 3
  command '/var/lib/mysql/backup.sh'
  user 'mysql'
end