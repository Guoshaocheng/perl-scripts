#!/usr/bin/perl
#-----------------------------------------------
#
#      Filename : hex2bin.pl
#
#        Author : Guoshaocheng - Ougsch@gmail.com
#   Description : ---
#        Create : 2018-01-03 16:30:42
# Last Modified : 2018-01-04 15:22:18
#-----------------------------------------------

$/ = '';
$hex = $ARGV[0];
($bin = $hex) =~ s/(\w+)\.(\w+)/$1\.bin/;

%h2b = (0 => "0000",
1 => "0001", 2 => "0010", 3 => "0011",
4 => "0100", 5 => "0101", 6 => "0110",
7 => "0111", 8 => "1000", 9 => "1001",
a => "1010", b => "1011", c => "1100",
d => "1101", e => "1110", f => "1111",
);

open (HEX, "<", $hex);
open (BIN, ">", $bin);

while (<HEX>) {
        chomp;
        ($binary = $_) =~ s/(.)/$h2b{lc $1}/g;
        # print $binary, "\n";
}
print BIN $binary;
close HEX;
close BIN;
