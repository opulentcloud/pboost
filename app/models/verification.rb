class Verification < ActiveRecord::Base
  # begin associations
  belongs_to :user
  has_one :import, class_name: 'VerificationImport', as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :import
  has_one :export, class_name: 'VerificationExport', as: :attachable, dependent: :destroy
  # end associations

  # begin public instance methods
  def build_export!
	  # get the file from the private S3 url and write it to a temp file.
		tempfile = download_from_s3
    # read in all the rows
		data = CSV.read(tempfile.path, headers: true).map { |row| row.to_hash }
		
		# Lookup each voter and add them and their county to the row
		new_data = []
		
		data.each do |old_row|
      voter_dob = Date.parse(old_row['DOB']) rescue ""
      search_index2 = Voter.build_search_index2(old_row['First Name'][0,4], old_row['Last Name'][0,4],voter_dob)
      voters = Voter.includes(:address).where(search_index2: search_index2)
      voters.each do |voter|
        new_row = old_row.merge("State File ID" => voter.state_file_id, "County" => voter.address.county_name)
        new_data << new_row
      end		  
		end
		
		
		# write the new rows back out to an export file.
		column_names = data.first.keys + ["State File ID", "County"]
		s = CSV.generate do |csv|
      csv << column_names
      new_data.each do |row|
        csv << row.values
      end
    end
  
    outfile = Tempfile.new(["#{user.id}-bulk-voter-verify",".csv"])
    outfile.write(s)
    outfile.rewind
    outfile.close
  
    self.build_export(mime_type: 'text/csv', origin_url: 'export file', description: 'export file', attached_file: outfile).save!
    update_attribute(:status, 'Processed')
  end
  # end public instance methods

private

  def download_from_s3
    tf = Tempfile.new(['import-file',".csv"], :binmode => true)
    tf.write(RestClient.get(import.attached_file.url, timeout: -1, open_timeout: 300))
    tf.rewind
    tf
  end
end
