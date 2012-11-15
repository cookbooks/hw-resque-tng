if(node[:resque_tng][:use_bluepill])
  server_exec = ''
  server_exec << "#{node[:resque_tng][:bundler_exec]} exec " if node[:resque_tng][:bundled]
  if(node[:resque_tng][:bundled])
    server_exec << "#{File.basename(node[:resque_tng][:rake_exec])} "
  else
    server_exec << "#{node[:resque_tng][:rake_exec]} "
  end
  server_exec << "#{node[:resque_tng][:rake_task]} RACK_ENV=#{node[:resque_tng][:environment]} "
  server_exec << "RAILS_ENV=#{node[:resque_tng][:environment]} QUEUES=#{node[:resque_tng][:queues]}"
  
  template File.join(node[:bluepill][:conf_dir], 'resque.pill') do
    source 'resque.pill.erb'
    mode 0644
    variables :exec => server_exec
  end

  bluepill_service 'resque' do
    action [:enable, :load, :start]
  end
else
  unless(node.platform_family == 'debian')
    raise 'Unsupported platform for direct init support. Please enable bluepill'
  end

  template '/etc/init.d/resque' do
    source 'resque.init.erb'
    mode 0755
  end

  service 'resque' do
    action [:enable, :start]
  end
end
