namespace :github do
  desc 'update all data from github'
  task :update_datas => [:environment] do
    User.all.each do |u|
      u.update_github_data!
    end
  end
end
