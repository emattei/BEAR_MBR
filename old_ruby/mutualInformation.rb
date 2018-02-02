seq={}
seq[1]="cttctcaaataactgtgcctctccctccagattctcaacctaacaactga"
seq[2]="ctgctcaccgacgaacgacattttccacaggagccgacctgcctacagac"
seq[3]="ggttccctcttggcttccatgtcctgacaggtggatgaagactacatcca"

contaTotale=Hash.new(0.0)
contaTotale["a"]=seq[1].count("a").to_f+seq[2].count("a").to_f+seq[3].count("a").to_f
contaTotale["c"]=seq[1].count("c").to_f+seq[2].count("c").to_f+seq[3].count("c").to_f
contaTotale["t"]=seq[1].count("t").to_f+seq[2].count("t").to_f+seq[3].count("g").to_f
contaTotale["g"]=seq[1].count("g").to_f+seq[2].count("g").to_f+seq[3].count("at").to_f

for i in 0..seq[1].size.to_i-2
	sum=0.0
	count=0
	countTot=0
	contatore=Hash.new(0.0)
	contatoreSingolo1=Hash.new(0.0)
	contatoreSingolo2=Hash.new(0.0)
	seq.each{|k,v|
		contatore["#{v[i]}#{v[i+1]}"]=contatore["#{v[i]}#{v[i+1]}"]+1.0
		contatoreSingolo1["#{v[i]}"]=contatoreSingolo1["#{v[i]}"]+1.0
		contatoreSingolo2["#{v[i+1]}"]=contatoreSingolo2["#{v[i+1]}"]+1.0
		count=count+1
	}
	contatore.each{|k,v|
		sum=sum+((v.to_f/count.to_f)*Math.log2((v.to_f/count.to_f)/((contatoreSingolo1[k[0]]/count.to_f)*(contatoreSingolo2[k[1]]/count.to_f))))
	}
	print i+1,"\t",sum,"\n"
end


