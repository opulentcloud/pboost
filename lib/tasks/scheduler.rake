desc "This task is called by the Heroku scheduler add-on once per day"
task update_voters_age: :environment do

  ActiveRecord::Base.connection.execute("UPDATE voters SET age = date_part('year', age(voters.dob)) where date_part('month', voters.dob) = date_part('month', current_date) AND date_part('day', voters.dob) = date_part('day', current_date)")

end

