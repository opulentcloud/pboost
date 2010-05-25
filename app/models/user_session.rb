#authlogic handles all of the session details
class UserSession < Authlogic::Session::Base
	logout_on_timeout true
end

