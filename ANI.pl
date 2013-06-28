#!/usr/bin/perl -w
use strict;
use FindBin qw($Bin);
use Getopt::Long;
use List::Util qw(min);
use Cwd qw(abs_path);


=head1 Name

    ANI.pl
    Date: June 23th, 2013
    Contact: kevinchjp@gmail.com

=head1 Description
    
    This program calculates Average Nucleotide Identity (ANI) based on genomes of a pair of prokaryotes.

=head1 Usage
    
    perl ANI.pl --fd formatdb --bl blastall --qr one strain genome --sb the other strain genome --od output directory --help (optional)

    Arguments explained
    bl: Directory of blastall excecutable file
    fd: Directory of BLAST formatdb excecutable file
    qr: Query strain genome sequence in FASTA format
    sb: Subject strain genome sequence in FASTA format
    od: output directory
    help: print this help information

=head1 Example

    perl ANI.pl -bl ./blast-2.2.23/bin/blastall -fd ./blast-2.2.23/bin/formatdb -qr strain1.fa -sb strain2.fa -od result

=cut
my ($qr,$sb,$od,$fd,$bl,$hl);
GetOptions(
    "qr=s" => \$qr,
    "sb=s" => \$sb,
    "od=s" => \$od,
    "fd=s" => \$fd,
    "bl=s" => \$bl,
    "help" => \$hl
          );
die `pod2text $0` unless $qr && $sb && $od && $bl && $fd;
die `pod2text $0` if $hl;

$qr=abs_path($qr);
$sb=abs_path($sb);
unless(-d $od){`mkdir $od`;}

#Split query genome and write segments in $od/Query.split
my $chop_len = 1020; 
$/ = "\n>";
open QR,$qr or die "$qr $!\n";
open CR,">$od/Query.split";
while(<QR>){
    chomp;
    s/>//g;
    my ($scaf,$seq) = split /\n/,$_,2;
    my $scaf_name = (split /\s+/,$scaf)[0];
    $seq =~ s/\s+//g;
    my @cut = ($seq =~ /(.{1,$chop_len})/g);
    for my $cut_num (0..$#cut){
        next if length($cut[$cut_num]) < 100; 
        my $sgmID = "$scaf_name\_$cut_num";
        print CR ">$sgmID\n$cut[$cut_num]\n";
    }
}
close QR;close CR;
$/ = "\n";

#BLAST alingment
`ln -sf $sb $od/Subject.fa`;
`$fd -i $od/Subject.fa -p F`;
`$bl -i $od/Query.split -d $od/Subject.fa -X 150 -q -1 -F F -e 1e-15 -m 8 -a 2 -o $od/raw.blast -p blastn`;

#Set Identity and Alignment Percentage cut off following paper of JSpecies
my $id_cut = 30;
my $cvg_cut = 70;

my ($ANI,%qr_best,$sumID,$count);
open BL,"$od/raw.blast" or die "raw.blast $!\n";
while(<BL>){
    chomp;
    my @t = split;
    next if $t[3] < 100;
    next if exists $qr_best{$t[0]}; $qr_best{$t[0]} = 1; #only use best hit for every query segments
    next if $t[2]<=$id_cut;
    next if ($t[3]*100/1020) < $cvg_cut;
    $sumID += $t[2];
    $count++;
}
close BL;
$ANI = $sumID/$count;
print "$qr VS $sb\n ANI: $ANI\n";
