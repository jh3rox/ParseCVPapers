#!/usr/bin/perl
#
# Parsing cvpapers on the web (html->txt)
# http://www.cvpapers.com/index.html
#
use strict;
use warnings;
use utf8;
use HTML::TreeBuilder;

# Input(HTML) & Output(TXT)
my $inHtml = "./cvpapers_cvpr2013.html";
my $outTxt = "./cvpapers_cvpr2013.txt";

# Parsing HTML 
my $tree = new HTML::TreeBuilder;
$tree->parse_file($inHtml);
$tree->eof();

# Finding Titles(<dt>) & Authors(<dd>) from HTML
my @dtItems = $tree->look_down('id', 'content')->find('dt');
my @ddItems = $tree->look_down('id', 'content')->find('dd');
$tree = $tree->delete;
my $nNumDt = $#dtItems;
my $nNumDd = $#ddItems;
if( $nNumDt != $nNumDd ){
    print "Unexpected HTML format!\n";
    exit;
}

# Making TXT file by using tab (\t) separator
open( OUT, ">$outTxt" ) or die "$!";
printf( OUT "No \t Title \t Author \n" );
for( my $i=0; $i<=$nNumDt; $i++ ){
    printf OUT "%d \t \"%s\" \t \"%s\" \n",
            $i+1, $dtItems[$i]->as_text, $ddItems[$i]->as_text;
}
close (OUT);

print "[Input]", $inHtml ,"\n";
print "[Output]", $outTxt ,"\n";
print "Successfully finished!!\n";
