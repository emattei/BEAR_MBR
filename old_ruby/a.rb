File.open(ARGV[0],"r") do |f|
	while line=f.gets
		print line
		l1=f.gets.chomp.size.to_i
		l2=f.gets.chomp.size.to_i
		if l1!=l2
			print "ERROR\n"
		end
	end
end
