#!/bin/bash

echo "Backing up pdb_seqres.txt to pdb_seqres_bak.txt"
cp data/pdb_seqres/pdb_seqres.txt data/pdb_seqres/pdb_seqres_bak.txt
echo "Removing incorrect sequences from pdb_seqres.txt"
bioawk -c fastx '{if ($seq !~ /.*[0-9].*/) {print ">"$name" "$comment"\n"$seq}}' \
    data/pdb_seqres/pdb_seqres_bak.txt > data/pdb_seqres/pdb_seqres.txt
