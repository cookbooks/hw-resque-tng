unless(node[:resque_tng][:bundled])
  gem_package 'resque'
end

if(node[:resque_tng][:use_bluepill])
  include_recipe 'bluepill'
end

if(node[:resque_tng][:redis][:name] || node[:resque_tng][:redis][:role])
  redis_search = if(node[:resque_tng][:redis][:name])
      "name:#{node[:resque_tng][:redis][:name]}"
    else
      "role:#{node[:resque_tng][:redis][:role]}"
    end

  if(node[:resque_tng][:redis][:common_env])
    redis_search << " AND chef_environment:#{node.chef_environment}"
  end

  redis_res = search(:node, redis_search).first
  if(redis_res.size > 1)
    Chef::Log.warn "Expected one redis node. Found #{redis_res.size} nodes. (#{redis_res})"
  end

  redis_node = redis_res.first
end

if(redis_node)
  node.default[:resque_tng][:redis][:ipaddress] = redis_node[:ipaddress]
  node.default[:resque_tng][:redis][:port] = redis_node[:redis][:listen_port]
end

config_dir = if(node[:resque_tng][:config_dir])
    node[:resque_tng][:config_dir]
  else
    File.join(node[:resque_tng][:app_dir], 'config')
  end

directory File.join(config_dir, 'initializers') do
  owner node[:resque_tng][:owner]
  group node[:resque_tng][:group]
  recursive true
end

template File.join(config_dir, 'initializers', 'resque.rb') do
  source 'resque.config.erb'
  mode 0644
end
