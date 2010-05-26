#migration_helpers.rb
module MigrationHelpers

	#this helper method is specific to mysql database.
	#example on_options = ON DELETE CASCADE ON UPDATE CASCADE
	def add_foreign_key(from_table, from_column, to_table, on_options)
		constraint_name = "fk_#{from_table}_#{from_column}"
		
		case ActiveRecord::Base.connection.adapter_name
		
		when 'PostgreSQL'

		execute %{ALTER TABLE #{from_table}
							ADD CONSTRAINT #{constraint_name} 
							FOREIGN KEY (#{from_column}) REFERENCES #{to_table} (id)
							#{on_options};}
		
		else
		
		execute %{alter table #{from_table}
							add foreign key #{constraint_name} (#{from_column})
							references #{to_table} (id)
							#{on_options};}
		end
	end

	#this helper method is specific to mysql database.
	def remove_foreign_key(from_table, from_column)
		constraint_name = "fk_#{from_table}_#{from_column}"

		case ActiveRecord::Base.connection.adapter_name
		
		when 'PostgreSQL'

		execute %{ALTER TABLE #{from_table} DROP CONSTRAINT #{constraint_name};}
		
		else
		
		execute %{alter table #{from_table} drop foreign key #{constraint_name};}
		
		end
	end

end
