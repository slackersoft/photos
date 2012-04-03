namespace :jshint do
  task :specs do
    include_paths = JSHint::Utils.paths_from_command_line('paths')
    exclude_paths = JSHint::Utils.paths_from_command_line('exclude_paths')

    if include_paths && exclude_paths.nil?
      # if you pass paths= on command line but not exclude_paths=, and you have exclude_paths
      # set in the config file, then the old exclude pattern will be used against the new
      # include pattern, which may be very confusing...
      exclude_paths = []
    end

    lint = JSHint::Lint.new paths: include_paths, exclude_paths: exclude_paths, config_path: 'config/jshint_specs.yml'
    lint.run
  end
end

task :jshint => 'jshint:specs'
