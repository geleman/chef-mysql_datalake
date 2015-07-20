include_recipe 'lvm::default'

lvm_volume_group 'logs' do
  physical_volumes ['/dev/sdc']
  logical_volume 'logfiles' do
    group 'logs'
    size '100%VG'
    filesystem 'ext4'
    mount_point location: '/logs', options: 'noatime,data=ordered'
  end
end

directory '/logs/mysql' do
  owner 'root'
  group 'root'
  mode '0750'
  recursive true
  action :create
end

directory '/logs/mysql/bin-logs' do
  owner 'root'
  group 'root'
  mode '0750'
  recursive true
  action :create
end

directory '/logs/mysql/relay-logs' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end
