
task rewrite_file: :environment do
  file = File.open("#{Rails.root}/db/fixtures/voters_maryland.csv", 'r')

  cnt = 0  
  new_file = Tempfile.new(['maryland_voters_rewrite','.txt'], :binmode => true)
  file.each_line do |line|
    cnt += 1
    puts cnt
    #if cnt == 1505406
      new_line = line.chars.select{|i|i.valid_encoding?}.join
      #new_line = line.encode("UTF-8", :invalid => :replace, :replace => "\t")
      new_line = new_line.gsub("\u0000","")
      new_file.puts new_line
    #  break
    #end
    #new_file.puts line
  end
  new_file.close
  file.close
  system "mv #{new_file.path} #{Rails.root}/db/fixtures/voters_maryland.txt"
  #system "gedit #{new_file.path}"
end
