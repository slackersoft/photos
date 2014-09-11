STAGES = %w(production)

def create_and_push(stage, revision = nil)
  auto_tag = AutoTagger::Base.new(stages: STAGES, stage: stage, verbose: true, push_refs: false, refs_to_keep: 100)
  sha = revision || auto_tag.last_ref_from_previous_stage.try(:sha)
  tag = auto_tag.create_ref(sha)
  sh "git push origin #{tag.name}"
  auto_tag.delete_locally
  auto_tag.delete_on_remote
end

task :before_deploy do
  sh "git fetch --tags"
end

task :after_deploy do
  each_heroku_app do |stage|
    create_and_push(stage.name, stage.revision)
  end
  Rake::Task['autotag:list'].invoke
end

namespace :autotag do
  desc "Create an autotag for stage, default: #{STAGES.first}"
  task :create, :stage do |t, args|
    create_and_push(args[:stage] || STAGES.first)
  end

  desc "Show auto tagger history"
  task :list do
    puts "** AUTO TAGGER: release tag history:"
    auto_tag = AutoTagger::Base.new(stages: STAGES, offline: true)
    STAGES.each do |stage|
      ref = auto_tag.refs_for_stage(stage).last
      if ref
        log = %x{git log -1 --format=oneline #{ref.sha}}.chomp
        log = log[0..5] + log[40..-1]
      else
        log = "none"
      end
      puts " ** %-12s %s" % [stage, log]
    end
  end
end
