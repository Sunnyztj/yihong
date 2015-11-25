rails_env = ENV['RACK_ENV'] || 'production'
worker_processes 2
working_directory '/home/deploy/yihong/current'

listen '/tmp/yihong.sock', :backlog => 2048
listen 5001, :tcp_nopush => true

timeout 60
pid "/home/deploy/yihong/shared/pids/yihong.pid"
preload_app  true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

stderr_path '/home/deploy/yihong/shared/log/yihong.log'

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
     Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end