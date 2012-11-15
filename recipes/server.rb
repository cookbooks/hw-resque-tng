if(node[:resque_tng][:use_bluepill])
  template File.join(node[:bluepill][:conf_dir], 'resque.pill') do
    source 'resque.pill.erb'
    mode 0644
  end

  bluepill_service 'resque' do
    action [:enable, :load, :start]
  end
else
  template '/etc/init.d/resque' do
    source 'resque.init.erb'
    mode 0755
  end

  service 'resque' do
    action [:enable, :start]
  end
end
