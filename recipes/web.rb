include_recipe 'resque-tng::server'

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
      :exec => "#{"#{node[:resque_tng][:bundler_exec]} exec" if node[:resque_tng][:bundled]} " <<
        "#{node[:resque_tng][:bundled] ? File.basename(node[:resque_tng][:web][:exec]) : node[:resque_tng][:web][:exec]} " <<
        "--env #{node[:resque_tng][:environment]} --pid-file #{node[:resque_tng][:web][:pid_file]} " <<
        "--port #{node[:resque_tng][:web][:port]} " <<
        "#{"--server #{node[:resque_tng][:web][:server]}" if node[:resque_tng][:web][:server]}"
    )
  end

  bluepill_service 'resque-web' do
    action [:enable, :load, :start]
  end
else
  template '/etc/init.d/resque_web' do
    source 'resque_web.init.erb'
    variables(
      :el => node.platform_family == 'rhel'
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

