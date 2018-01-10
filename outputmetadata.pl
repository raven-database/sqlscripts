#!/usr/bin/perl
use strict;
use DBI;
use Getopt::Long;
use Pod::Usage;
use lib '/home/modupe/SCRIPTS/SUB';
use passw;
use routine;

#ARGUMENTS
my($specifics,$output,$metadata, $sequence);
GetOptions("1|a|in|in1|list=s"=>\$specifics,"2|b|out|output=s"=>\$output,"m"=>\$metadata,"z"=>\$sequence);


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - G L O B A L  V A R I A B L E S- - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# DATABASE VARIABLES
my ($dbh, $sth, $syntax, @row);
our ($VERSION, $DATE, $AUTHOR) = DEFAULTS;
$dbh = mysql();

#OPENING OUTPUT FILE
open (OUT, ">$output")  or die "it aint opening";

#SPECIFYING LIBRARIES OF INTEREST
my @headers = split("\,", $specifics);

if ($metadata) {
  # HEADER print out
  print OUT "libraryid\tbirdid\tspecies\tline\ttissue\tmethod\t";
  print OUT "indexname\tchipresult\tscientist\tdate\tnotes\n";

  $syntax = "select * from bird_libraries where libraryid in 
        ($specifics);";
  $sth = $dbh->prepare($syntax);
  $sth->execute or die "SQL Error: $DBI::errstr\n";
  
  while (@row = $sth->fetchrow_array() ) { 
        foreach my $real (0..$#row-1){
          print OUT "$row[$real]\t";
        }
        print OUT "$row[$#row]\n";
  }
}
if ($sequence) {
  #HEADER print
  print OUT "Library id\tLine\tSpecies\tTissue\tTotal reads\tMapped reads\tGenes\tIsoforms\tVariants\tSNPs\tINDELs\tSequences\tDate\n";
  
  $syntax = "select v.libraryid, v.line, v.species, v.tissue, t.totalreads, v.mappedreads, v.genes,
              v.totalVARIANTS VARIANTS,v.totalSNPs SNPs, v.totalINDELs INDELs, f.sequences Sequences, t.Date Date from MappingStats as t
              join vw_libmetadata as v on t.libraryid = v.libraryid join Syntaxes as f on f.libraryid = v.libraryid where v.libraryid in 
              ($specifics);";
  $sth = $dbh->prepare($syntax);
  $sth->execute or die "SQL Error: $DBI::errstr\n";
  
  while (@row = $sth->fetchrow_array() ) { 
        foreach my $real (0..$#row-1){
          print OUT "$row[$real]\t";
        }
        print OUT "$row[$#row]\n";
  }
}
# DISCONNECT FROM THE DATABASE
$dbh->disconnect();
close(OUT);



# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - -T H E  E N D - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit;
