
Organization.all.each do |organization|
	case AccountType.find(organization.account_type_id).name
		when 'Pre-Pay' then	organization.build_prepay_account
		when 'Invoice' then organization.build_invoice_account
	end
	organization.save!
end
