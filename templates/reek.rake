if Rails.env.development?
  require 'reek/rake/task'

  Reek::Rake::Task.new do |task|
    task.source_files  = '{app,lib,spec}/**/*.rb'
    task.fail_on_error = false
  end
end

