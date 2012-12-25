#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Notiz::Application.load_tasks


require 'sprite_factory'
namespace :assets do
  desc 'recreate sprite images and css'
  task :resprite => :environment do
    SpriteFactory.library = :rmagick
    SpriteFactory.csspath = "<%= asset_path 'sprites/$IMAGE' %>"
    dirs = Dir.glob("#{Rails.root}/app/assets/images/sprites/*/")
    dirs.each do |path|
      dir_name = path.split("/").last
      SpriteFactory.run!("app/assets/images/sprites/#{dir_name}",
                          :output_style => "app/assets/stylesheets/sprites/#{dir_name}.scss.erb",
                          :selector => ".#{dir_name}_")
    end
  end
end

