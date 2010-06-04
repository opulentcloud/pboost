module ActiveRecord
	module Validations
		module Partial
			def valid_for_attributes?( *attr_names )
				return validate_for_attributes(attr_names)
			end
			
			def validate_for_attributes( attr_names )
				attr_names.map! { |a| a.to_s }
				
				unless valid?
					our_errors = Array.new
					errors.each { |attr,error|
						if attr_names.include? attr
							our_errors << [attr,error]
						end
					}
					
					errors.clear
					our_errors.each { |attr,error| errors.add(attr,error) }
					return false unless errors.empty?
				end
				return true
			end	
		end
	end
end

ActiveRecord::Base.class_eval do
	include ActiveRecord::Validations::Partial
end
