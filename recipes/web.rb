include_recipe 'resque-tng::server'

web_exec = ''
web_exec << "#{node[:resque_tng][:bundler_exec]} exec" if node[:resque_tng][:bundled]
if(node[:resque_tng][:bundled])
  web_exec << "#{File.basename(node[:resque_tng][:web][:exec]} "
else
  web_exec << "#{node[:resque_tng][:web][:exec]} "
end
web_exec << "--env #{node[:resque_tng][:environment]} "
web_exec << "--pid-file #{node[:resque_tng][:web][:pid_file]} "
web_exec << "--port #{node[:resque_tng][:web][:port]} "
web_exec << "#{"--server #{node[:resque_tng][:web][:server]}" if node[:resque_tng][:web][:server]}"

if(node[:resque_tng][:web][:server] && !node[:resque_tng][:bundled])
  gem_package node[:resque_tng][:web][:server]
end

if(node[:resque_tng][:web][:use_bluepill])
  template File.join(node[:bluepill][:conf_dir], 'resque-web.pill') do
    source 'resque_default.pill.erb'
    variables(
      :process_name => 'resque-web',
      :app_name => 'resque-web',
      :pid_file => node[:resque_tng][:web][:pid_file],
      :exec => web_exec
    )
  end

  bluepill_service 'resque-web' do
    action [:enable, :load, :start]
  end
else
  template '/etc/init.d/resque_web' do
    source 'resque_web.init.erb'
    variables(
      :el => node.platform_family == 'rhel',
      :exec => web_exec
    )
    mode 0755
  end

  service 'resque_web' do
    action [:enable, :start]
  end
end

if(node[:resque_tng][:iptables])
  iptables_rule 'resque_web_port'
end

