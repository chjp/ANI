This perl script calculates average nucleotide identity (ANI) for a pair of prokaryotic genomes. ANI has been used by microbial community to measure genetic distance of prokaryotes. This perl script is developed based on algorithm described in the article “Richter, M. and R. Rossello-Mora (2009). "Shifting the genomic gold standard for the prokaryotic species definition." Proc Natl Acad Sci U S A 106(45): 19126-19131.”

    The authors of this article have developed JSpecies (http://www.imedea.uib.es/jspecies/index.html) for calculating ANI, but the software runs only on graphical user interface. When I need to calculate ANI for hundreds of strains, it is not convenient to submit all the genome sequences to JSpecies. Therefore I implement the ANI algorithm in the perl script that runs in Unix command line mode.

    The script has been tested on some random selected strains, and results were consistent with JSpecies.
