my @long ;
# my $in_file = "struct_test_1.hex" ;
my $in_file = glob "*.hex" ;
(my $out_file = $in_file) =~ s!(.*)\x2e.*!$1\.coe! ;
open (IN,"<",$in_file) || die "Could not open "," $in_file.","[Info : $!]" ;
while (<IN>) {
    if (m!(?<LEN>\w{2})(?<ADDR>\w{4})(?<TYPE>\w{2})(?<DATA_00>\w{4})(?<DATA_01>\w{4})(?<DATA_10>\w{4})(?<DATA_11>\w{4})(?<VERIFY>\w{2})!) {
        push @long, $+{DATA_00} ;
        push @long, $+{DATA_01} ;
        push @long, $+{DATA_10} ;
        push @long, $+{DATA_11} ;
    }
}
close IN ;

open (OUT,">",$out_file) || die "Could not open "," $out_file.","[Info : $!]" ;

for (@long) {
    print OUT $_,"\n" ;
}

close OUT ;
