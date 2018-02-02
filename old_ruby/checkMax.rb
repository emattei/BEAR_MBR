i=0
File.open(ARGV[0],"r") do |f|
	while line=f.gets
		if i!=10 and i!=11
			field=line.chomp.split("\t")[0..-1]
			field[10]=0.0
			field[11]=0.0
			field2=field.collect {|j| j.to_f }		
			if field2.max != field2[i].to_f
				print i,"\t",field2.index(field2.max),"\n"
			end
		end
		i=i+1
	end
end
