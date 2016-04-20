set :stages, %w(staging production)
set :stages_dir, 'config/deploy'
set :default_stage, 'staging'
set :rvm_ruby_string, "1.1.1@truba"


require 'mina/multistage'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'

load File.expand_path('../unicorn-tasks.rb', __FILE__)

set_default :keep_releases, 5

set :repository, "dfbdfbdfb"
set :branch, 'master'

set :term_mode, nil

set :shared_paths, [
    'config/secrets.yml',
    'config/database.yml',
    'log',
    'public/system'
]

task :environment do
  invoke :'rvm:use[1.1.1@truba]'
end

task setup: :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/secrets.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/secrets.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/application.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/application.yml'."]


  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/public"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/system"]
end

desc 'Deploys the current version to the server.'
task deploy: :environment do
  deploy do
    invoke :'git:clone'
    invoke :'bundle:install'
    invoke :'deploy:link_shared_paths'
    invoke :'rails:db_create'
    invoke :'rails:db_migrate'

    # queue! "cd #{deploy_to}/current"
    # queue! "bundle exec rake db:seed RAILS_ENV=#{:environment}"

    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      invoke :'unicorn:restart'
    end
  end
end


desc "Seed data to the database"
task seed: :environment do
    queue "cd #{deploy_to}/current"
    queue "bundle exec rake db:seed RAILS_ENV=#{default_stage}"

  to :launch do
    invoke :'unicorn:restart'
  end

end