#!/usr/bin/perl

foreach $argnum (0 .. $#ARGV) {
    if ($ARGV[$argnum] =~ /-b(.)/) {
	$begin=$1;
    } elsif ($ARGV[$argnum] =~ /-e(.)/) {
	$end=$1;
    } elsif ($ARGV[$argnum] =~ /-g(.+)/) {
	$grammar=$1;
    } elsif ($ARGV[$argnum] =~ /\.g$/) {
	$gfile=$ARGV[$argnum];
    }
}

open (GI, "<$gfile") || 
{ warn("Could not open inputfile \"$gfile\"") };

while(<GI>) {
    s/(module\s+antlr.stringtemplate.language.)DefaultTemplate([a-zA-Z_0-9]+)/$1$grammar$2/;
    s/(grammar\s+)([a-zA-Z_0-9]+)/$1$grammar/;
    s/(BEGIN:\s+')\$(')/$1$begin$2/;
    s/(END:\s+')\$(')/$1$end$2/;
    s/(COMMENTBEGIN:\s+')\$(!')/$1$begin$2/;
    s/(COMMENTEND:\s+'!)\$(')/$1$end$2/;
    s/(beginSymbol=\')\$(\'\;)/$1$begin$2/;
    s/(endSymbol=\')\$(\'\;)/$1$end$2/;
    print "$_";
}

close GI;
 
