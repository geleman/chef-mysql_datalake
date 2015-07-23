include_recipe 'lvm::default'

lvm_volume_group 'data' do
  physical_volumes ['/dev/sdb']
  logical_volume 'datafiles' do
    group 'data'
    size '100%VG'
    filesystem 'ext4'
    mount_point location: '/data', options: 'noatime,data=ordered'
  end
end

directory '/data/mysql' do
  owner 'root'
  group 'root'
  mode '0750'
  recursive true
  action :create
end