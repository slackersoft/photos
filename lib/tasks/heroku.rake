task :after_deploy do
  each_heroku_app do |stage|
    create_and_push(stage.name)
  end
end
