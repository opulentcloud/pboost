namespace :utils do

  desc 'Create an Account table record for each Organization on file'
  task :create_accounts => :environment do
    seed_file = File.join(Rails.root, 'db', 'create_accounts.rb')
    load(seed_file) if File.exist?(seed_file)
  end

end
