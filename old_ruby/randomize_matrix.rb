=begin
###Matrice randomizzata per riga###
m=0
File.open(ARGV[0],"r") do |f|
	while line=f.gets
		field=line.chomp.split("\t")
		field.shuffle!.delete("Infinity")
		if m!=10 and m!=11
			print field[0..9].join("\t"),"\t",Float::INFINITY,"\t",Float::INFINITY,"\t",field[12..-1].join("\t"),"\n"
		else
			for i in 0..84
				print Float::INFINITY,"\t"
			end
			print Float::INFINITY,"\n"
		end
		m+=1
	end
end

###randomizzazione globale###
a=[]
m=0
#File.open("./matriceStructFam","r") do |f|
File.open(ARGV[0],"r") do |f|
	while line=f.gets
		field=line.chomp.split("\t")
		#field.shuffle!
		#print field.join("\t")
		if m!=10 and m!=11
		field.each_with_index{|x,n|
			if n!=10 and n!=11
				a.push(x)
			end
			n=n+1
		}end
		m+=1
	end
end
a1=a.shuffle
cont=0
for i in 0..84
	for j in 0..84
		if i==10 or i==11 or j==10 or j==11
			print Float::INFINITY,"\t"
		else
			print a1[cont],"\t"
			cont+=1
		end
	end
	print "\n"
end
=end
###identità###
LOOP=["j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","^"]
STEM=["a","b","c","d","e","f","g","h","i","="]
STEM_branch=["A","B","C","D","E","F","G","H","I","J"]
LEFTINTERNALLOOP=["?","!","\"","#","$","%","&","\'","(",")","+"]
BULGELEFT=["["]
LEFTINTERNALLOOP_branch=["?","K","L","M","N","O","P","Q","R","S","T","U","V","W"]
BULGELFETBRANCH=["{"]
RIGHTINTERNALLOOP=["?","2","3","4","5","6","7","8","9","0",">"]
BULGERIGHT=["]"]
RIGHTINTERNALLOOP_branch=["?","Y","Z","~","?","_","\|","/","\\","@"]
BULGERIGTHBRANCH=["}"]

TOTAL=["a","b","c","d","e","f","g","h","i","=","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","^","!","\"","#","$","%","&","\'","(",")","+","2","3","4","5","6","7","8","9","0",">","[","]",":","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","{","Y","Z","~","?","_","|","/","\\","}","@"]
TOTAL.each{|x1|
	TOTAL.each{|x2|
		if x2!="a"
			print "\t"
		end
		if LOOP.include?(x1) and LOOP.include?(x2)
			print 1
		elsif STEM.include?(x1) and STEM.include?(x2)
			print 1
		elsif STEM_branch.include?(x1) and STEM_branch.include?(x2)
			print 1
		elsif LEFTINTERNALLOOP.include?(x1) and LEFTINTERNALLOOP.include?(x2)
			print 1
		elsif BULGELEFT.include?(x1) and BULGELEFT.include?(x2)
			print 1
		elsif LEFTINTERNALLOOP_branch.include?(x1) and LEFTINTERNALLOOP_branch.include?(x2)
			print 1
		elsif BULGELFETBRANCH.include?(x1) and BULGELFETBRANCH.include?(x2)
			print 1
		elsif RIGHTINTERNALLOOP.include?(x1) and RIGHTINTERNALLOOP.include?(x2)
			print 1
		elsif BULGERIGHT.include?(x1) and BULGERIGHT.include?(x2)
			print 1
		elsif RIGHTINTERNALLOOP_branch.include?(x1) and RIGHTINTERNALLOOP_branch.include?(x2)
			print 1
		elsif BULGERIGTHBRANCH.include?(x1) and BULGERIGTHBRANCH.include?(x2)
			print 1
		elsif x1==":" and x2==":"
			print 1
		else
			print 0
		end
		
	}
	print "\n"
}
=begin
TOTAL.each{|x1|
	TOTAL.each{|x2|
		if x2!="a"
			print "\t"
		end
			if x1==x2
				print 1
			else
				print 0
			end
		
	}
	print "\n"
}
=end
