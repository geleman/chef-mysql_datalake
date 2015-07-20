mount '/dev/shm' do
  device 'tmpfs'
  action [:umount, :disable]
end

directory '/tmp/shm' do
  owner 'root'
  group 'root'
  mode  '0777'
  recursive true
  action :create
end

mount '/tmp/shm' do
  device 'tmpfs'
  fstype 'tmpfs'
  options 'rw,size=1G,noatime'
  action [:mount, :enable]
end
