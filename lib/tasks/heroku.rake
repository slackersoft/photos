STAGES = %w(ci production)

def create_and_push(stage)
  auto_tag = AutoTagger::Base.new(stages: STAGES, stage: stage, verbose: true, push_refs: false, refs_to_keep: 100)
  tag = auto_tag.create_ref(auto_tag.last_ref_from_previous_stage.try(:sha))
  sh "git push origin #{tag.name}"
  auto_tag.delete_locally
  auto_tag.delete_on_remote
end

task :after_deploy do
  each_heroku_app do |stage|
    create_and_push(stage)
  end
end
