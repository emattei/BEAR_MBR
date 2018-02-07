#!/usr/bin/env python3

from Bio import AlignIO
import urllib
import requests
import sys

#Input: Rfam accession
def eprint(*args, **kwargs):
	# http://stackoverflow.com/questions/5574702/
	print(*args, file=sys.stderr, **kwargs)


def create_url(rfam_acc):

	url = "http://rfam.xfam.org/family/%s/alignment/stockholm" %(rfam_acc)

	return(url)

def retrieve_alignment(rfam_acc,out="ali_tmp"):
	output = open(out, "w")
	try:
		response = urllib.request.urlopen(create_url(rfam_acc))
		output.write(response.read().decode('utf-8'))
	except:
		output.close()
		eprint(rfam_acc + " does not exist")
		return

	return out

def crea_constraint(rfam_acc, ali_stock):
	
	IUPAC=["R","Y","M","K","S","W","B","D","H","V","N"]
	CONSTRAINTS=[">","<","_"]

	ss_cons = ["."] * ali_stock.get_alignment_length()

	try:
		SS = ali_stock.column_annotations["secondary_structure"]
		RF = ali_stock.column_annotations["reference_annotation"]
	except:
		eprint("No constraints possible for %s!" %(rfam_acc))
		return False

	
	out_fasta=open("./constraints/"+rfam_acc+".constraints","w")

	
	brackets = [idx for idx, ss in enumerate(SS) if ss in CONSTRAINTS[0:2] ]

	for idx in brackets:
		ss_cons[idx] = SS[idx]

	conserved = [idx for idx, rf in enumerate(RF) if rf.istitle() and 
							not rf in IUPAC]

	for idx in set(conserved) - set(brackets):
		ss_cons[idx] = "x"
	
	for record in ali_stock:
		out_fasta.write(">" + record.id + "\n")
		gaps = [idx for idx, nuc in enumerate(record.seq) if nuc == "-"]

		out_fasta.write(str(record.seq).replace("-","") + "\n")
		out_fasta.write("".join([ss_con for idx, ss_con in enumerate(ss_cons) if not idx in gaps]) + "\n")
		
	out_fasta.close()



acc = []
with open("accession.rfam5","r") as f:
	for line in f:
		acc.append(line.strip())
#for i in range(1,177):
#	rfam_acc = "RF" + str(i).zfill(5)
#	ali_fnp = retrieve_alignment(rfam_acc)
#	ali_fh = open(ali_fnp, encoding = "ISO-8859-1")
#	ali = AlignIO.read(ali_fh, "stockholm")
#	crea_constraint(rfam_acc, ali)	
ali_fh = open("Rfam.seed", encoding = "ISO-8859-1")	
alis = AlignIO.parse(ali_fh, "stockholm")

count = 0

for ali in alis:
	rfam_acc = acc[count]
	crea_constraint(rfam_acc, ali)	
	count += 1
