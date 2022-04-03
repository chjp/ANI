# Implement ANI in Perl
This perl script calculates average nucleotide identity (ANI) for a pair of prokaryotic genomes. ANI has been used by microbial community to measure genetic distance of prokaryotes. This perl script is developed based on algorithm described in the article 
```
“Richter, M. and R. Rossello-Mora (2009). "Shifting the genomic gold standard for the prokaryotic species definition." Proc Natl Acad Sci U S A 106(45): 19126-19131.”
```

The authors of this article have developed JSpecies (http://www.imedea.uib.es/jspecies/index.html) for calculating ANI, but the software runs only on graphical user web interface. It was not convenient to submit hundreds of genome sequences to JSpecies, therefore I implemented the ANI algorithm in the perl script that runs in Unix command line mode.

The script has been tested on some random selected strains, and results were consistent with JSpecies.

# Usage
You can run ANI.pl via via docker or standalong version

- Docker approach
```
git clone https://github.com/chjp/ANI.git
cd ANI/
sudo docker build ./
sudo docker run \
--user $(id -u):$(id -g) \
-v <your_working_directory>:/var/ \
perl ANI.pl <options>
```
- Standalone approach
```
# download BLAST version 2.2.23
wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+//2.2.23/ncbi-blast-2.2.23+-x64-linux.tar.gz
tar -xzcf ncbi-blast-2.2.23+-x64-linux.tar.gz
perl ANI.pl -bl ./blast-2.2.23/bin/blastall -fd ./blast-2.2.23/bin/formatdb -qr strain1.fa -sb strain2.fa -od result
```
