include_recipe 'resque-tng'

unless(node[:resque_tng][:bundled])
  gem_package 'resque-pool'
end

if(node[:resque_tng][:redis][:ipaddress])

  directory File.dirname(node[:resque_tng][:pid_file]) do
    owner node[:resque_tng][:owner]
    group node[:resque_tng][:group]
    recursive true
  end

  if(node[:resque_tng][:use_bluepill])
    template File.join(node[:bluepill][:conf_dir], 'resque-pool.pill') do
      source 'resque_default.pill.erb'
      variables(
        :app_name => 'resque-poool',
        :process_name => 'resque-pool',
        :exec => "#{"#{node[:resque_tng][:bundler_exec]} exec " if node[:resque_tng][:bundled]}" <<
          "#{node[:resque_tng][:bundled] ? File.basename(node[:resque_tng][:pool_exec]) : node[:resque_tng][:pool_exec]} " <<
          "--environment #{node[:resque_tng][:environment]} --pidfile #{node[:resque_tng][:pid_file]} " <<
          "--daemon"
      )
    end
    bluepill_service 'resque-pool' do
      action [:enable, :load, :start]
      subscribes :load, resources(:template => File.join(node[:bluepill][:conf_dir], 'resque-pool.pill')), :immediately
    end
  else
    template '/etc/init.d/resque_pool' do
      source 'resque_pool.init.erb'
      variables(
        :el => node.platform_family == 'redhat'
      )
      mode 0755
    end

    service 'resque_pool' do
      action [:enable, :start]
    end
  end
else
  raise 'Failed to locate redis node. Unable to setup resque!'
end
