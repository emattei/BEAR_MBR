h={}
File.open(ARGV[0],"r") do |f|
	while line=f.gets
		field=line.chomp.split(" ")
		h[field[0].split("_")[1]]=true
	end
end

count={}
name=""
File.open(ARGV[1],"r") do |f|
	while line=f.gets
		if line[0..0]!=">"
			if h[line.chomp.split(" ")[0]]
				print line.chomp.split(" ")[1],"\n"
				count[name]+=1
			end
		else
			print line
			name=line
			count[name]=0
		end
	end
end
