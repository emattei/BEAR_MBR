#!/usr/bin/env python3

from Bio import SeqIO
import sys
import os
import errno
import gzip
import pathlib
import re
import glob


def eprint(*args, **kwargs):
	# http://stackoverflow.com/questions/5574702/
	print(*args, file=sys.stderr, **kwargs)

ss_cons = {}

fastq_fnp = sys.argv[1] # path to folded .fastq extension
#for i in `ls *.folded`;do awk 'BEGIN{c=1}{if(c==1){print "@"substr($1,2);c+=1}else if(c==2){print $1;c+=1}else{print "+";print$1;c=1}} ' ${i} > ${i%%.folded}.fastq;done


files = glob.glob(fastq_fnp + "/*.fastq")

for f in files:
	with open(f, "r") as handle:
		for record in SeqIO.parse(handle, "fastq"):
			ss_cons[record.id.replace("/","_")] = "".join([chr(c+33) for c in record.letter_annotations["phred_quality"]])


#bralibase folder containing k2, k3, ..., k15

bralibase_fnp = sys.argv[2]

#output folder

outfolder = sys.argv[3]

files = glob.glob(bralibase_fnp + "/**/*.raw.fa", recursive=True)

keys = set(ss_cons.keys())
for f in files:
	with open(f, "r") as handle:
		tmp={}
		for record in SeqIO.parse(handle, "fasta"):
			tmp[record.id]=record.seq
		if set(tmp.keys()) < keys:
			outfile=os.path.join(outfolder,f.replace(bralibase_fnp,""))
			
			if not os.path.exists(os.path.dirname(outfile)):
				try:
					os.makedirs(os.path.dirname(outfile))
				except OSError as exc: # Guard against race condition
					if exc.errno != errno.EEXIST:
						raise
			
			
			with open(outfile,"w") as wh:
				for k,v in tmp.items():
					wh.write(">"+k+"\n"+str(v)+"\n"+ss_cons[k]+"\n")


