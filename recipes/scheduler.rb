unless(node[:resque_tng][:use_bluepill])
  raise 'Scheduler is currently only supported via bluepill'
end

unless(node[:resque_tng][:bundled])
  gem_package 'resque-scheduler'
end

template File.join(node[:bluepill][:config_dir], 'resque-scheduler.pill') do
  source 'resque_default.pill.erb'
  variables(
    :app_name => 'resque-scheduler',
    :process_name => 'resque-scheduler',
    :daemonize => true,
    :exec => "#{"#{node[:resque_tng][:bundler_exec]} exec " if node[:resque_tng][:bundled]}" <<
      "#{node[:resque_tng][:bundled] ? File.basename(node[:resque_tng][:rake_exec]) : node[:resque_tng][:rake_exec]} " <<
      "#{"-f #{node[:resque_tng][:scheduler][:rakefile]} " if node[:resque_tng][:scheduler][:rakefile]}" << 
      "resque:scheduler"
  )
end

bluepill_service 'resque-scheduler' do
  action [:enable, :load, :start]
  subscribes :load, resources(:template => File.join(node[:bluepill][:config_dir], 'resque-scheduler.pill'))
end
