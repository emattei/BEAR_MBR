#TOTAL=["a","b","c","d","e","f","g","h","i","=","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","^","!","\"","#","$","%","&","\'","(",")","+","2","3","4","5","6","7","8","9","0",">","[","]",":"]
TOTAL=["a","b","c","d","e","f","g","h","i","=","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","^","!","\"","#","$","%","&","\'","(",")","+","2","3","4","5","6","7","8","9","0",">","[","]",":","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","{","Y","Z","~","?","_","|","/","\\","}","@"]
#TOTAL=["a","b","c","d","e","f","g","h","i","=","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","^","!","\"","#","$","%","&","\'","(",")","+","2","3","4","5","6","7","0",">","[","]",":","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","W","{","Y","Z","~","?","_","|","/","\\","}","@"]
COSTI={"a"=>"1","b"=>"2","c"=>"3","d"=>"4","e"=>"5","f"=>"6","g"=>"7","h"=>"8","i"=>"9","="=>"100","j"=>"1","k"=>"2","l"=>"3","m"=>"4","n"=>"5","o"=>"6","p"=>"7","q"=>"8","r"=>"9","s"=>"10","t"=>"11","u"=>"12","v"=>"13","w"=>"14","x"=>"15","y"=>"16","z"=>"17","^"=>"100","!"=>"2","\""=>"3","#"=>"4","$"=>"5","%"=>"6","&"=>"7","\'"=>"8","("=>"9",")"=>"10","+"=>"100","2"=>"2","3"=>"3","4"=>"4","5"=>"5","6"=>"6","7"=>"7","8"=>"8","9"=>"9","0"=>"10",">"=>"100","["=>"1","]"=>"1",":"=>"1"}
#TOTAL=["s","l","b","i",":"]
align={}
#align_test_RF00001

prng=Random.new(1234)
count=0
@l=[]

h1={}
File.open("./listaStructatorFamPlus","r") do |f2|
#File.open("./listaMod","r") do |f2|
#File.open("../listaMod","r") do |f2|
  while line2=f2.gets
	if line2[0..0]!=">"
	       h1[line2.chomp]="ok"
	end
  end
end

#File.open("./align.txt","r") do |f|
File.open(ARGV[0],"r") do |f|
	while line=f.gets
		if line[0..0]==">"
			if h1[line.chomp[1..-1]]=="ok"
			#print line.chomp[1..-1],"\n"
	#		if count<=15 and prng.rand(1..1000)<=25
				@name=line.chomp[1..-1]
				align[@name]=Array.new()
				line=f.gets
				align[@name].push(line.chomp)
				@s=true
				@l.push(@name)
				count+=1
			else
				@s=false
			end
		else
			if @s
				align[@name].push(line.chomp)
			end
		end	
	end
end
#print @l,"\n"
@m=Array.new(TOTAL.size.to_i){Array.new(TOTAL.size.to_i,1)}
#@m.each_index {|i| @m[i][i]=0}
num_pa=0
freq=Hash.new(0)
dove=1
align.each{|k,v|
#	print k,"\t#{dove} su #{lista.size}\n"
	for i in 0..v.size.to_i-2
		for j in i+1..v.size.to_i-1
			#print v[i],"\t",v[j],"\n"
			if v[i].size.to_i<v[j].size.to_i
				min=v[i].size.to_i
			else
				min=v[j].size.to_i
			end
			tmp1=v[i].split(//)
			tmp2=v[j].split(//)
			prev1="x"
			prev2="x"
			for z in 0..tmp1.size.to_i-1#min.to_i-1
				if TOTAL.index(tmp1[z])!=nil and TOTAL.index(tmp2[z])!=nil #(tmp1[z]!="." and tmp2[z]!=".") and (tmp1[z]!=":" and tmp2[z]!=":") and (tmp1[z]!="." and tmp2[z]!=":") and (tmp1[z]!=":" and tmp2[z]!=".")
					#if prev1!=tmp1[z] or prev2!=tmp2[z]
						if tmp2[z]==tmp1[z]
							#print tmp2[z],"\t",tmp1[z],"\n"
							@m[TOTAL.index(tmp1[z])][TOTAL.index(tmp2[z])]+=1
							num_pa+=1
							prev1=tmp1[z]
							prev2=tmp2[z]
							freq[tmp1[z]]+=1
							freq[tmp2[z]]+=1
						else
							#print tmp2[z],"\t",tmp1[z],"\n"
							@m[TOTAL.index(tmp2[z])][TOTAL.index(tmp1[z])]+=1
							@m[TOTAL.index(tmp1[z])][TOTAL.index(tmp2[z])]+=1
							num_pa+=1
							prev1=tmp1[z]
							prev2=tmp2[z]
							#print tmp1[z],"\t"
							#print tmp2[z],"\n"
							freq[tmp1[z]]+=1
							freq[tmp2[z]]+=1
						end
					#end
				end
			end
		end
	end
	#dove+=1
}

z=freq.values.inject{|somma,b| somma+b}
freq.each_key{|k|
	freq[k]=freq[k].to_f/z.to_f
}

@m.each_index{|i|
	@m.each_index{|j|
		if i==j
#			@m[i][j]=Math.log10(((@m[i][j].to_f/num_pa.to_f)/(freq[TOTAL[i]].to_f*freq[TOTAL[j]].to_f*COSTI[TOTAL[i]].to_f*COSTI[TOTAL[j]].to_f)))
			@m[i][j]=Math.log10(((@m[i][j].to_f/num_pa.to_f)/(freq[TOTAL[i]].to_f*freq[TOTAL[j]].to_f)))
#			@m[i][j]=(@m[i][j].to_f/num_pa.to_f)
		else
#			@m[i][j]=Math.log10(((@m[i][j].to_f/num_pa.to_f)/(2.0*freq[TOTAL[i]].to_f*freq[TOTAL[j]].to_f*COSTI[TOTAL[i]].to_f*COSTI[TOTAL[j]].to_f)))
			@m[i][j]=Math.log10(((@m[i][j].to_f/num_pa.to_f)/(2.0*freq[TOTAL[i]].to_f*freq[TOTAL[j]].to_f)))
#			@m[i][j]=(@m[i][j].to_f/num_pa.to_f)
		end
	}
}

@m.each{|x|
	print x.join("\t"),"\n"
}
#for i in 0..@m.size.to_i-1
#	for j in 0..i
#		if @m[i][j]==0 and i!=10 and i!=11 and j!=10 and j!=11
#			print TOTAL[i],"\t",TOTAL[j],"\n"
#		end
#	end
#end
