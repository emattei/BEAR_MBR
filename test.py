#!/usr/bin/env python3

from Bio import AlignIO
import urllib
import requests


url = "http://rfam.xfam.org/family/RF00360/alignment/stockholm"
data = urllib.request.urlopen(url)

output = open("000", "w")
output.write(data.read().decode('utf-8'))
output.close()

alignment_fh = open("000", encoding = "ISO-8859-1")
alignments = AlignIO.read(alignment_fh, "stockholm")
print("Alignment length %i" % alignments.get_alignment_length())

count=0
for ali in alignments:
	count += 1
	print(count)
	#print("Alignment length %i" % ali.get_alignment_length())
	print(ali)

	#for record in ali :
	#       print(record.seq + " " + record.id)

#for line in data:
#	print(line.decode('utf-8'))
#res = requests.get(url)
#alignment_fh = open(res.text, encoding = "ISO-8859-1")
