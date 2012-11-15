## Resque for the next generation

This is a cookbook for installing and configuring Resque without
need of the entire kichen sink (or pantry). It can be run directly,
with a pool, and even with bluepill support for monitoring.

### Recipes

* `server` -> direct resque workers
* `server-pool` -> use resque-pool to run workers
* `scheduler` -> use scheduler
* `web` -> enable dashboard interface

### Configuration

* `node[:resque_tng][:bundled] = true` -> Use bundler within app dir
* `node[:resque_tng][:app_dir] = '/var/www/current'` -> Application directory
* `node[:resque_tng][:config_dir] = nil` -> Configuration directory
* `node[:resque_tng][:environment] = 'production'` -> Environment to run within
* `node[:resque_tng][:queues] = '*'` -> Queues workers should process
* `node[:resque_tng][:worker_count] = 2` -> Number of workers
* `node[:resque_tng][:redis][:role] = nil` -> Node role of redis server
* `node[:resque_tng][:redis][:name] = nil` -> Node name of redis server
* `node[:resque_tng][:redis][:common_env] = true` -> Search within common chef environment
* `node[:resque_tng][:redis][:ipaddress] = '127.0.0.1'` -> IP address of redis server
* `node[:resque_tng][:redis][:port] = 6379` -> Port of redis server
* `node[:resque_tng][:owner] = 'www-data'` -> Resque user
* `node[:resque_tng][:group] = 'www-data'` -> Resque group
* `node[:resque_tng][:pid_file] = '/var/run/resque/resque_pool.pid'` -> Resque pid file
* `node[:resque_tng][:pool_exec] = File.join(node.languages.ruby.bin_dir, 'resque-pool')` -> Exec location for resque-pool
* `node[:resque_tng][:bundler_exec] = File.join(node.languages.ruby.bin_dir, 'bundle')` -> Exec location for bundler
* `node[:resque_tng][:rake_exec] = File.join(node.languages.ruby.bin_dir, 'rake')` -> Exec location for rake
* `node[:resque_tng][:rake_task] = 'resque:work'` -> Rake task for resque
* `node[:resque_tng][:use_bluepill] = false` -> Use bluepill to manage process
* `node[:resque_tng][:bluepill][:start_time] = 30` -> Grace time for startup
* `node[:resque_tng][:bluepill][:stop_time] = 30` -> Grace time for shutdown
* `node[:resque_tng][:bluepill][:restart_time] = 60` -> Grace time for restart
* `node[:resque_tng][:web][:iptables] = false` -> Open port for dashboard access
* `node[:resque_tng][:web][:port] = 80` -> Port dashboard should listen on
* `node[:resque_tng][:web][:pid_file] = '/var/run/resque/resque_web.pid'` -> Pid location for dashboard process
* `node[:resque_tng][:web][:use_bluepill] = false` -> Use bluepill to manage dashboard process
* `node[:resque_tng][:web][:bluepill][:start_time] = 30` -> Grace time for startup
* `node[:resque_tng][:web][:bluepill][:stop_time] = 30` -> Grace time for shutdown
* `node[:resque_tng][:web][:bluepill][:restart_time] = 60` -> Grace time for restart
* `node[:resque_tng][:web][:server] = nil` -> Server to use for dashboard (allowed mongrel and thin)

## Infos
* Repo: https://github.com/hw-cookbooks/resque-tng
