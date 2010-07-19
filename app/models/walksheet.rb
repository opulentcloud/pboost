class Walksheet < ContactList
	
	def contact_list_id
		self.id
	end

	#ignores if odd or even address
	def voters_by_route_all
		if self.gis_region.blank?
			return nil if self.route_index > 0
			return self.voters.all(:joins => :address, :order => 'state, city, street_name, street_prefix, is_odd, street_no_int, street_no_half, street_type, street_suffix, apt_type, apt_no,  last_name, first_name')
		end
		
		poly = self.gis_region.geom2[self.route_index]
		return nil if poly.nil?
		self.voters.all(:joins => :address, :conditions => "(addresses.geom && '#{poly.as_hex_ewkb}' ) AND ST_contains('#{poly.as_hex_ewkb}',addresses.geom::geometry)", :order => 'state, city, street_name, street_prefix, is_odd, street_no_int, street_no_half, street_type, street_suffix, apt_type, apt_no,  last_name, first_name')
	end

	#this is the data returned to print a walksheet.
	def voters_by_route(is_odd = nil)
	#debugger
		return voters_by_route_all if is_odd.nil?
		if self.gis_region.blank?
			return nil if !self.route_index.nil?
			return self.voters.all(:conditions => "(addresses.is_odd = #{is_odd})", :joins => :address, :order => 'state, city, street_name, street_prefix, is_odd, street_no_int, street_no_half, street_type, street_suffix, apt_type, apt_no,  last_name, first_name')
		end
		
		poly = self.gis_region.geom2[self.route_index]
		return nil if poly.nil?
		self.voters.all(:joins => :address, :conditions => "(addresses.geom && '#{poly.as_hex_ewkb}' ) AND ST_contains('#{poly.as_hex_ewkb}',addresses.geom::geometry) AND (addresses.is_odd = #{is_odd})", :order => 'state, city, street_name, street_prefix, is_odd, street_no_int, street_no_half, street_type, street_suffix, apt_type, apt_no,  last_name, first_name')
	end
	
end
