class String

  def is_upper?
    !!self.match(/\p{Upper}/)
  end

  def is_lower?
    !!self.match(/\p{Lower}/)
    # or: !self.is_upper?
  end

end

IUPAC=["R","Y","M","K","S","W","B","D","H","V","N"]
ACCEPTED=[">","<","."]

def caricaAllineamento(file)
	h={}
	File.open(file,"r") do |f|
		while line=f.gets
			if line[0..6]=="#=GF AC"
				@name=line.chomp.split(" ")[2].strip
				if h[@name]==nil
					h[@name]={}
				end
			elsif line.chomp[0..6]=="#=GF SQ"
				f.gets
				line=f.gets
				while line.chomp[0..1]!="//"
					if line.chomp.split(" ")[1]=="SS_cons"
						if h[@name][line.chomp.split(" ")[1]]==nil
							h[@name][line.chomp.split(" ")[1]]=Array.new()
							h[@name][line.chomp.split(" ")[1]].push(line.chomp.split(" ")[2])
						else
							h[@name][line.chomp.split(" ")[1]].push(line.chomp.split(" ")[2])
						end
						line=f.gets
						if line.chomp.split(" ")[1]=="RF"
							if h[@name][line.chomp.split(" ")[1]]==nil
								h[@name][line.chomp.split(" ")[1]]=Array.new()
								h[@name][line.chomp.split(" ")[1]].push(line.chomp.split(" ")[2])
							else
								h[@name][line.chomp.split(" ")[1]].push(line.chomp.split(" ")[2])
							end
							line=f.gets
						else
							h[@name]["RF"]="UNK"
							#print line
						end
					elsif 	line.chomp.split(" ")[1]!=nil #and h1["#{@name}_#{line.chomp.split(" ")[0]}"]=="ok"
						if h[@name][line.chomp.split(" ")[0]]==nil
							h[@name][line.chomp.split(" ")[0]]=Array.new()
							h[@name][line.chomp.split(" ")[0]].push(line.chomp.split(" ")[1])
						else
							h[@name][line.chomp.split(" ")[0]].push(line.chomp.split(" ")[1])
						end
						line=f.gets
					else
						line=f.gets			
					end
				end
				
			end
		end
	end
	return h
end

def creaConstraint(h)
	constraints={}
	h.each{|k,v|
		if h[k]["RF"]!="UNK"
			constraints[k]={}
			@SS_cons=h[k]["SS_cons"].join.split(//)
			@cons=""
			@RF=h[k]["RF"].join.split(//)
				@RF.each_with_index{|o,i|
					if @SS_cons[i]==">" or @SS_cons[i]=="<"
						@cons+=@SS_cons[i]
					else
						if o.is_upper?
							if IUPAC.include?(o)==false
								if @SS_cons[i]=="."
									@cons+="x"
								else
									if ACCEPTED.include?(@SS_cons[i])==true
										if i==0 and @SS_cons[i]==">"
											@cons+="."
										else
											@cons+=@SS_cons[i]
										end
									else
										@cons+="."
									end

								end
							else
								@cons+="."
							end
						else
							@cons+="."
						end
					end
				}
			#constraints[k]=@cons
		end
		v.each{|k1,v1|
			@res_str=[]
			@res_con=[]
			if k1!="RF" and k1!="SS_cons" and h[k]["RF"]!="UNK"
				v1.join.split(//).each_with_index{|o,i|
					if o!="."
						if @res_str.size.to_i==0
							@res_str.push(o)
							if @cons[i]==">"
								@res_con.push(".")
							else
								@res_con.push(@cons[i])
							end
						else
							@res_str.push(o)
							@res_con.push(@cons[i])
						end
					end
				}	
				#print k1,"\t",@res_con,"\n"
				constraints[k][k1]=@res_con.join
			end
		}
	}
	return constraints
end

def caricaFamiglie(file)
	h={}
	File.open(file,"r") do |f|
		while line=f.gets
			h[line.chomp]=true
		end
	end
	return h
end

def caricaRidondanza(file)
	h={}
	File.open(file,"r") do |f|
		while line=f.gets
			if line[0..0]==">"
				field=line.chomp.split(";")
				h["#{field[2].split(" ")[0]}"]=true
			end
		end
	end
	return h
	
end

def creaFileFolding(res,famiglie,constraints)
	s=File.open("inputRNAfold","w")
	res.each{|k,v|
	#if famiglie[k]
		if res[k]["RF"]!="UNK"	
			v.each{|k1,v1|
				if k1!="RF" and k1!="SS_cons" #and ridondanza[k1]
					s.write(">#{k}_#{k1}\n")
					s.write("#{v1.join.delete(".")}\n")
					s.write("#{constraints[k][k1]}\n")
				end
		}
		end
	#end
	}
end

def creaAllineamentiFinali(res)
	s=File.open("./alignRfamTotale","w")
	s1=File.open("./alignFramTotale_with_acc","w")
	tmp=""
	File.open("./famiglie.bear","r") do |f|
		while line=f.gets
			field=line.chomp.split("_")
			famiglia=field[0][1..-1]
			accession=field[1]
			f.gets
			f.gets
			b=f.gets.chomp
			if famiglia!=tmp
				tmp=famiglia
				s.write(">#{famiglia}\n")
				s1.write(">#{famiglia}\n")
			end
			s1.write("#{accession}\t")
			i=0
			res[famiglia][accession].join.split(//).each{|o|
				if o=="."
					s.write(".")
					s1.write(".")
				else
					s.write(b[i])
					s1.write(b[i])
					i=i+1
				end
			}
			s.write("\n")
			s1.write("\n")

			
		end
	end

end

def creaMatrice()
conta=0
	@m=Array.new(TOTAL.size.to_i){Array.new(TOTAL.size.to_i,0)}
	@m.each_index {|i| @m[i][i]=0}
	num_pa=0
	count=0
	freq=Hash.new(0)
	dove=1
	align={}
	File.open("./branchCompletoCorrezione.align","r") do |f|
		while line=f.gets
			if line[0..0]==">"
				@name=line.chomp[1..-1]
				align[@name]=Array.new()
				line=f.gets
				align[@name].push(line.chomp)
				@s=true
				count+=1
			else
				if @s
					align[@name].push(line.chomp)
				end
			end
		end
	end
	align.each{|k,v|
		for i in 0..v.size.to_i-2
			for j in i+1..v.size.to_i-1		
				tmp1=v[i].split(//)
				tmp2=v[j].split(//)
				for z in 0..tmp1.size.to_i-1
					if TOTAL.index(tmp1[z])!=nil and TOTAL.index(tmp2[z])!=nil
						if tmp2[z]==tmp1[z]
							@m[TOTAL.index(tmp1[z])][TOTAL.index(tmp2[z])]+=1
							num_pa+=1
							freq[tmp1[z]]+=1
							freq[tmp2[z]]+=1
						else
							@m[TOTAL.index(tmp2[z])][TOTAL.index(tmp1[z])]+=1
							@m[TOTAL.index(tmp1[z])][TOTAL.index(tmp2[z])]+=1
							num_pa+=1
							freq[tmp1[z]]+=1
							freq[tmp2[z]]+=1
						end
					end
				end
			end
		end
	}
	z=freq.values.inject{|somma,b| somma+b}
		freq.each_key{|k|
		freq[k]=freq[k].to_f/z.to_f
	}
zzzz=0.0
	@m.each_index{|i|
		@m.each_index{|j|
			if i==j
				#if @m[i][j]!=0
				#	@m[i][j]=(@m[i][j].to_f/num_pa.to_f)/(freq[TOTAL[i]].to_f*freq[TOTAL[j]].to_f)
				#end
				@m[i][j]=Math.log10(((@m[i][j].to_f/num_pa.to_f)/(freq[TOTAL[i]].to_f*freq[TOTAL[j]].to_f))) #normale
				#else
				#@m[i][j]=Float::INFINITY
				#end
				#@m[i][j]=(Math.log(((@m[i][j].to_f/num_pa.to_f)/(freq[TOTAL[i]].to_f*freq[TOTAL[j]].to_f)))/(Math.log(2)/3.0)) #scalata e arrotondata
				#r=(@m[i][j]).infinite?
				#if r==nil
				#	@m[i][j]=@m[i][j].to_f.round
				#end
			else
				#if @m[i][j]!=0
			#		@m[i][j]=(@m[i][j].to_f/num_pa.to_f)/(2.0*freq[TOTAL[i]].to_f*freq[TOTAL[j]].to_f)
				#end
			 	@m[i][j]=Math.log10(((@m[i][j].to_f/num_pa.to_f)/(2.0*freq[TOTAL[i]].to_f*freq[TOTAL[j]].to_f))) #normale
				#else
				#@m[i][j]=Float::INFINITY
				#end
				#@m[i][j]=(Math.log(((@m[i][j].to_f/num_pa.to_f)/(2.0*freq[TOTAL[i]].to_f*freq[TOTAL[j]].to_f)))/(Math.log(2)/3.0)) #scalata e arrotondata
				#r=(@m[i][j]).infinite?
				#if r==nil
				#	@m[i][j]=@m[i][j].to_f.round
				#end
			end
		}
	}

#	for i in 0..@m.size.to_i-1
		#for j in 0..i
#			zzzz=zzzz+@m[i][0].to_f
		#end
#	end
	print conta,"\n"
	return @m
#	return zzzz
end

def creaMatriceMediaFamiglia()

	@m=Array.new(TOTAL.size.to_i){Array.new(TOTAL.size.to_i,0.0)}
	@s1=Array.new(TOTAL.size.to_i){Array.new(TOTAL.size.to_i,0.0)}
	@tmp=Array.new(TOTAL.size.to_i){Array.new(TOTAL.size.to_i,0.0)}

	numeroCoppieTotali=0
	freq=Hash.new(0)

	align={}
	File.open("./align","r") do |f|
		while line=f.gets
			if line[0..0]==">"
				@name=line.chomp[1..-1]
				align[@name]=Array.new()
				line=f.gets
				align[@name].push(line.chomp)
				@s=true
			else
				if @s
					align[@name].push(line.chomp)
				end
			end
		end
	end
	grandezzaTotaleFamiglie=0.0
	numeroTotaleFamiglie=0
	

	align.each{|k,v|
		count_tmpUguali=Array.new(TOTAL.size.to_i){Array.new(TOTAL.size.to_i,0.0)}
		count_tmpDoppi=Array.new(TOTAL.size.to_i){Array.new(TOTAL.size.to_i,0.0)}
		grandezzaFamiglia=v.size.to_f
		grandezzaTotaleFamiglie=grandezzaTotaleFamiglie+(1.0/grandezzaFamiglia.to_f)
		numeroTotaleFamiglie+=1
		for i in 0..v.size.to_i-2
			for j in i+1..v.size.to_i-1	
				tmp1=v[i].split(//)
				tmp2=v[j].split(//)
				for z in 0..tmp1.size.to_i-1
					if TOTAL.index(tmp1[z])!=nil and TOTAL.index(tmp2[z])!=nil
						if tmp2[z]==tmp1[z]
							index=TOTAL.index(tmp1[z])
							count_tmpUguali[index][index]+=1.0
							@s1[index][index]+=1.0
							numeroCoppieTotali+=1
							freq[tmp1[z]]+=1
							freq[tmp2[z]]+=1
						else
							index1=TOTAL.index(tmp1[z])
							index2=TOTAL.index(tmp2[z])
							@s1[index2][index1]+=1.0
							@s1[index1][index2]+=1.0
							count_tmpDoppi[index2][index1]+=1.0
							count_tmpDoppi[index1][index2]+=1.0
							numeroCoppieTotali+=1
							freq[tmp1[z]]+=1
							freq[tmp2[z]]+=1
						end
					end
				end
			end
		end
		for i in 0..@m.size.to_i-1
			for j in 0..@m.size.to_i-1
				if count_tmpDoppi[i][j]!=0.0 and i!=j
					@m[i][j]+=count_tmpDoppi[i][j].to_f/grandezzaFamiglia.to_f
				elsif i==j and count_tmpUguali[i][j]!=0.0
					@m[i][j]+=count_tmpUguali[i][j].to_f/grandezzaFamiglia.to_f
#					print i,"\t",j,"\t",count_tmpUguali[i][j].to_f,"\t",@m[i][j],"\n"
				end
			end
		end
		
	}
	z=freq.values.inject{|somma,b| somma+b}
	freq.each_key{|k|
		freq[k]=freq[k].to_f/z.to_f
	}
	@m.each_index{|i|
		@m.each_index{|j|
			if i==j
#				@m[i][j]=Math.log(((@m[i][j].to_f/num_pa.to_f)/(freq[TOTAL[i]].to_f*freq[TOTAL[j]].to_f))) #normale
				if @m[i][j]!=0.0
					#print i,"\t",j,"\t",@m[i][j],"\t",numeroCoppieTotali,"\t",numeroTotaleFamiglie,"\t",grandezzaTotaleFamiglie,"\t",freq[TOTAL[i]].to_f,"\n"
					@m[i][j]=@m[i][j].to_f/grandezzaTotaleFamiglie.to_f
#@m[i][j]=@m[i][j].to_f/((numeroCoppieTotali.to_f/(numeroTotaleFamiglie.to_f*grandezzaTotaleFamiglie.to_f)))
#					@m[i][j]=(Math.log(((@m[i][j].to_f/((numeroCoppieTotali.to_f/numeroTotaleFamiglie.to_f)*(grandezzaTotaleFamiglie.to_f)))/(freq[TOTAL[i]].to_f*freq[TOTAL[j]].to_f)))/(Math.log(2)/3.0)).round #scalata e arrotondata
#				else
#					print i,"\t",j,"\n"
				end
			else
#				@m[i][j]=(@m[i][j].to_f/((num_pa.to_f/numeroTotaleFamiglie.to_f)*(grandezzaTotaleFamiglie.to_f)))
#				@m[i][j]=Math.log(((@m[i][j].to_f/num_pa.to_f)/(2.0*freq[TOTAL[i]].to_f*freq[TOTAL[j]].to_f))) #normale
				if @m[i][j]!=0.0
					#print i,"\t",j,"\t",@m[i][j],"\t",numeroCoppieTotali,"\t",numeroTotaleFamiglie,"\t",grandezzaTotaleFamiglie,"\t",freq[TOTAL[i]].to_f,"\t",freq[TOTAL[j]].to_f,"\n"
					@m[i][j]=@m[i][j].to_f/grandezzaTotaleFamiglie.to_f
#					@m[i][j]=(Math.log(((@m[i][j].to_f/((numeroCoppieTotali.to_f/numeroTotaleFamiglie.to_f)*(grandezzaTotaleFamiglie.to_f)))/(2.0*freq[TOTAL[i]].to_f*freq[TOTAL[j]].to_f)))/(Math.log(2)/3.0)).round #scalata e arrotondata
#				else
#					print i,"\t",j,"\n"
				end
			end
		}
	}
#	return @m
#	zzzz=0.0
	for i in 0..@m.size.to_i-1
		for j in 0..@m.size.to_i-1#0..i
#			zzzz=zzzz+@m[i][j].to_f
			@tmp[i][j]=@s1[i][j]/@m[i][j]
		end
	end
#	return @m,zzzz
	return @tmp
end



#TOTAL=["a","b","c","d","e","f","g","h","i","=","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","^","!","\"","#","$","%","&","\'","(",")","+","2","3","4","5","6","7","8","9","0",">","[","]",":"]
TOTAL=["a","b","c","d","e","f","g","h","i","=","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","^","!","\"","#","$","%","&","\'","(",")","+","2","3","4","5","6","7","8","9","0",">","[","]",":","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","{","Y","Z","~","?","_","|","/","\\","}","@"]

#res={}
#res=caricaAllineamento(ARGV[0])
#constraints={}
#constraints=creaConstraint(res)
#creaAllineamentiFinali(res)

#famiglie={}
#famiglie=caricaFamiglie(ARGV[1])
#ridondanza={}
#ridondanza=caricaRidondanza(ARGV[2])
#creaFileFolding(res,famiglie,constraints)
#%x[RNAfold --noPS -C < inputRNAfold > outputRNAfold]
s=File.open("outputRNAfold_noEnergieCompleto","w")
File.open("./outputRNAfold","r") do |f|
	while line=f.gets
		s.write(line)
		line=f.gets
		s.write(line)
		line=f.gets
		s.write(line.chomp.split(" ")[0])
		s.write("\n")
	end
end
%x[java -jar BearEncoder_BranchCompleto.jar outputRNAfold_noEnergieCompleto famiglie.Rfam]
=begin

allineamenti={}
allineamenti=creaAllineamentiFinali(res)
=end
#m=creaMatriceMediaFamiglia()
#m=creaMatrice()
#print a,"\n"
#@m.each{|x|
#	print x.join("\t"),"\n"
#}


