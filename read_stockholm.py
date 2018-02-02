#!/usr/bin/env python3


import sys

from Bio import AlignIO

alignment_fh = open(sys.argv[1])

alignment = AlignIO.read(alignment_fh, "stockholm")

print("Alignment length %i" % alignment.get_alignment_length())

for record in alignment :
    print(record.seq + " " + record.id)

print(record.letter_annotations['SS_cons'])
