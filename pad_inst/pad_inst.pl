#***********************************************
#
#      Filename: pad_inst.pl
#
#        Author: Guoshaocheng - Ougsch@gmail.com
#   Description: ---
#        Create: 2017-09-05 20:04:41
# Last Modified: 2017-09-15 11:54:47
#**********************************************/
my $set_name = $ARGV[0];
my $core_ports = $set_name.".txt";
my $chip_name = "soc_chip";
my $core_name = "soc_core";
my $pad_ring_name  = "pad_ring";
my $tab = "	";
my $digits;
my $inst_p;
my $inst_y;
my $inst_a;
my $inst_oe;
my $inst_p_list;
my $inst_y_list;
my $inst_a_list;
my $inst_oe_list;
my $inst;
my $inst_begin;
my $inst_end;
my %insth;
my %porth;
my %porth_digits;
my %wireh;
my $top_result;
my $pad_lib = "RCMCU_PLBMUX";
my $pad_num = 0;
my $pad_name;
my $high = "1'b1";
my $low = "1'b0";
my $output;
my $port_with_direction;
my $chip_pad;
my $chip_core;
my $chip_list;


&gen_much();
&gen_ports();
&gen_pad_ring();
#&gen_chip_top();
#&gen_chip_list();
#&gen_chip_wire();
#&inst_pad_ring();
#&inst_soc_core();
#&gen_soc_chip();
sub gen_much() {
	open (PORT_NAME, "<", $core_ports) or die "[Info:$!]\n";
	# my $i = 1; 
	# my $j = 0;
	# my $k = 0;
	my $inst_lib = sprintf("%-12s",$pad_lib);
	$inst_begin .= ".IE($high), .CS($high), .OS($low), .OD($low), .PU($low), .PD($low), .SR($low), .DR($low), .YA() );\n";
	while (<PORT_NAME>) {
		if (/^\s*input\s+(\[(\d)\s*\:\s*(\d)\])?\s*(\S+)\s*/) {
			# $i++;
			$inst_p_list = $4."_pad";
			$insth{inputs}{$inst_p_list} = $1;
			$inst_y_list= $4."_wire";
			$wireh{$inst_y_list} = $1;
			$porth{outputs}{$inst_y_list} = $1;
			$porth{inputs}{$inst_p_list} = $1;
			# print "$1\n";
			$digits = $2 - $3;
			# print "$digits\n";
			if ( $digits > 0 ) {
				foreach (0..$digits) {
					
					$inst_y = $4."_wire"."[".$_."]";
					$porth_digits{outputs}{$inst_y} = {};
					$inst_p = $4."_pad"."[".$_."]";
					$porth_digits{inputs}{$inst_p} = {};

					$pad_name = sprintf ("Pad_%-6s",$pad_num);
					#$inst_end = "(.P($inst_p), .Y($inst_y), .A($high), .OE($low), ";
					$inst_end = sprintf ("(.P\(%-23s\), \.Y\(%-24s\), \.A\(%-22s\), \.OE\(%-20s\)",$inst_p, $inst_y, $high, $low);
					$inst .= $pad_lib.$tab.$pad_name.$inst_end.$inst_begin;
					$pad_num++;
					#print "$1\n";
				}
			}
			else {
					$inst_y = $4."_wire";
					$porth_digits{outputs}{$inst_y} = {};
					$inst_p = $4."_pad";
					$porth_digits{inputs}{$inst_p} = {};

					$pad_name = sprintf ("Pad_%-6s",$pad_num);
					#$inst_end = "(.P($inst_p), .Y($inst_y), .A($high), .OE($low), ";
					$inst_end = sprintf ("(.P\(%-23s\), \.Y\(%-24s\), \.A\(%-22s\), \.OE\(%-20s\)",$inst_p, $inst_y, $high, $low);
					$inst .= $pad_lib.$tab.$pad_name.$inst_end.$inst_begin;
					$pad_num++;				
			}
		}
		elsif (/^\s*output\s+(\[(\d)\s*\:\s*(\d)\])?\s*(\S+)\s*/) {
			$inst_p_list = $4."_pad";
			$insth{outputs}{$inst_p_list} = $1;
			$inst_a_list= $4."_wire";
			$wireh{$inst_a_list} = $1;
			$porth{outputs}{$inst_p_list} = $1;
			$porth{inputs}{$inst_a_list} = $1;			
			# $j++;
			$digits = $2 - $3;
			# print "$1\n";
			# print "$digits\n";
			if ( $digits > 0 ) {			
				foreach (0..$digits) {			
					# $j++;
					$inst_a = $4."_wire"."[".$_."]";
					$porth_digits{inputs}{$inst_a} = {};
					$inst_p = $4."_pad"."[".$_."]";
					$porth_digits{outputs}{$inst_p} = {};


					$pad_name = sprintf ("Pad_%-6s",$pad_num);
					#$inst_end = "(.P($inst_p), .Y($low), .A($inst_a), .OE($low), ";
					$inst_end = sprintf ("(.P\(%-23s\), \.Y\(%-24s\), \.A\(%-22s\), \.OE\(%-20s\)",$inst_p, $low, $inst_a, $low);
					$inst .= $pad_lib.$tab.$pad_name.$inst_end.$inst_begin;
					$pad_num++;
					#print $1."\n";
				}
			}
			else {
				# $j++;
				$inst_a = $4."_wire";
				$porth_digits{inputs}{$inst_a} = {};
				$inst_p = $4."_pad";
				$porth_digits{outputs}{$inst_p} = {};

				$pad_name = sprintf ("Pad_%-6s",$pad_num);
				#$inst_end = "(.P($inst_p), .Y($low), .A($inst_a), .OE($low), ";
				$inst_end = sprintf ("(.P\(%-23s\), \.Y\(%-24s\), \.A\(%-22s\), \.OE\(%-20s\)",$inst_p, $low, $inst_a, $low);
				$inst .= $pad_lib.$tab.$pad_name.$inst_end.$inst_begin;
				$pad_num++;
				#print $1."\n";
			}
		}

		elsif (/^\s*inout\s*(\[(\d)\s*\:\s*(\d)\])?\s+(\S+)\s+(\S+)\s+(\S+)\s*/) {
			$inst_p_list = $4."_pad";
			$insth{inouts}{$inst_p_list} = $1;
			$inst_y_list= $4."_wire";
			$inst_a_list= $5."_wire";
			$inst_oe_list = $6."_wire";
			$wireh{$inst_y_list} = $1;
			$wireh{$inst_a_list} = $1;
			$wireh{$inst_oe_list} = $1;
			$porth{outputs}{$inst_y_list} = $1;
			$porth{inputs}{$inst_a_list} = $1;
			$porth{inputs}{$inst_oe_list} = $1;
			$porth{inouts}{$inst_p_list} = $1;						
			# $k++;
			# print "$1\n";
			# print "$5\n";
			$digits = $2 - $3;
			if ( $digits > 0 ) {			
				foreach (0..$digits) {					
					
					$inst_y = $4."_wire"."[".$_."]";
					$inst_a = $5."_wire"."[".$_."]";
					$inst_oe = $6."_wire"."[".$_."]";
					$inst_p = $4."_pad"."[".$_."]";
					$porth_digits{outputs}{$inst_y} = {};
					$porth_digits{inputs}{$inst_a} = {};
					$porth_digits{inputs}{$inst_oe} = {};
					$porth_digits{inouts}{$inst_p} = {};

					$pad_name = sprintf ("Pad_%-6s",$pad_num);
					#$inst_end = "(.P($inst_p), .Y($inst_y), .A($inst_a), .OE($inst_oe), ";
					$inst_end = sprintf ("(.P\(%-23s\), \.Y\(%-24s\), \.A\(%-22s\), \.OE\(%-20s\)",$inst_p, $inst_y, $inst_a, $inst_oe);
					$inst .= $pad_lib.$tab.$pad_name.$inst_end.$inst_begin;
					$pad_num++;
				}
			}
			else {
								# $k++;
				$inst_y = $4."_wire";
				$inst_a = $5."_wire";
				$inst_oe = $6."_wire";
				$inst_p = $4."_pad";
				$porth_digits{outputs}{$inst_y} = {};
				$porth_digits{inputs}{$inst_a} = {};
				$porth_digits{inputs}{$inst_oe} = {};
				$porth_digits{inouts}{$inst_p} = {};

				$pad_name = sprintf ("Pad_%-6s",$pad_num);
				#$inst_end = "(.P($inst_p), .Y($inst_y), .A($inst_a), .OE($inst_oe), ";
				$inst_end = sprintf ("(.P\(%-23s\), \.Y\(%-24s\), \.A\(%-22s\), \.OE\(%-20s\)",$inst_p, $inst_y, $inst_a, $inst_oe);
				$inst .= $pad_lib.$tab.$pad_name.$inst_end.$inst_begin;
				$pad_num++;
			}

		}

	}
	# print "$j\n";
	#print "$inst";
	#print "$i\n";
	#print "$j\n";
	#print "$k\n";
	# my @inputs = sort keys${porth{inputs}};
	# my @outputs = sort keys${porth{outputs}};
	# my @inouts = sort keys${porth{inouts};
	#printf "%-23s\n"x@inouts,@inouts;
	#print ($#inputs + 1)."\n";
	#print ($#outputs + 1)."\n";
	#print ($#inouts + 1)."\n";
	$top_result = "module".$tab.$pad_ring_name."\n"."\n"."("."\n";
	my @group_list = sort keys%porth;
	my $port_result;
	# my @del_list = sort keys$porth{outputs};
	#printf ("%-15s\n"x@del_list,@del_list);
	foreach my $port_group (@group_list) {
		my $port_type = $port_group;
		$port_type =~ s/(\S+)/\U$1/gi;
		$port_result .= "//  $port_type\n";
		my @port_list = sort keys${porth{$port_group}};
		#printf "%-23s"x@port_list, @port_list;
		#print ($#port_list + 1);
		#my $l = 0;
		foreach my $port (@port_list) {
			#$l++;
			if (($port_group eq $group_list[-1]) && ($port eq $port_list[-1])) {
				$port_result .= $tab.$tab.$port."\n";
			}
			else {
				$port_result .= $tab.$tab.$port.","."\n";
			}
			#print "$l\n";
		}
	}
	$top_result .= $port_result.");\n";
	#print $top_result;
}


sub gen_ports() {
	my @group_list = sort keys%porth;
	foreach my $port_group (@group_list) {
		#print "$port_group";
		my $port_type = $port_group;
		$port_type =~ s/(\S+)s/$1/g;
		#print "$port_type\n";
		my @port_list = sort keys${porth{$port_group}};
		#my @port_inout = sort keys${porth{inouts}};
		#printf "%-23s\n"x@port_inout, @port_inout;
		foreach my $port (@port_list) {
			# print "$port\n";
			# $port_with_direction .= $port_type.$tab.$port.";\n";
			# print "$porth{$port_group}{$port}\n";

			$port_with_direction .= sprintf ("%-10s%-8s%-20s;\n",$port_type, $porth{$port_group}{$port}, $port);

		}
		#print "*****************************\n";
	}
	#print "$port_with_direction\n";
}


sub gen_pad_ring() {
	$output = $top_result.$port_with_direction.$inst."\nendmodule";
	my $pad_result = $pad_ring_name."\.v";
	open (OUTPUT, ">", $pad_result) or die "[Info:$!\n]";
	print OUTPUT $output;
	# print "$pad_ring_name\n";
	print "Successfully generated pad_ring!!!\n";
}


sub gen_chip_top() {
	$chip_top = "module $chip_name\n\(\n";
	my @temp_group = sort keys%insth;
	foreach my $port_group (sort keys%insth) {
		my @temp_port = sort keys$insth{$port_group};
		my $type_uper = $port_group;		
		$type_uper =~ s/(\S+)/\U$1/g;
		$chip_top .= "\n$tab$tab// $type_uper\n";		
		foreach my $port (sort keys$insth{$port_group}) {
			if (($port eq $temp_port[-1]) && ($port_group eq $temp_group[-1])) {
				$chip_top .= $tab.$tab.$port."\n";
			}
			else {
				$chip_top .= $tab.$tab.$port.",\n";
			}
		}
	}
	$chip_top .= "\);\n\n";
	#print "$chip_top\n";
}


sub gen_chip_list() {
	my @temp_group = sort keys%insth;
	foreach my $port_group (sort keys%insth) {
		my @temp_port = sort keys$insth{$port_group};
		my $port_type = $port_group;
		$port_type =~ s/(\S+)s/$1/g;


		foreach my $port (sort keys$insth{$port_group}) {
			$chip_list .= sprintf ("%-10s%-8s%-24s;\n", $port_type, $insth{$port_group}{$port}, $port);

		}
	# print "$chip_list\n";
	}
	$chip_list .= "\n";
}


sub gen_chip_wire() {
	my @temp_wires = sort keys%wireh;
	foreach my $wire (@temp_wires) {
		# $chip_wire .= "wire".$tab.$wire.";\n";
		$chip_wire .= sprintf ("%-10s%-8s%-24s;\n", "wire", $wireh{$wire}, $wire);
	}
	#print "$chip_wire\n";
	$chip_wire .= "\n";
}


sub inst_pad_ring() {
	#my $i = 0;
	my $pad_ring_v = $pad_ring_name."\.v";
	my @pad_ring_list;
	#print $pad_ring_v;
	open (PRV, "<", $pad_ring_v) or die "[Info]:$!\n";
	$chip_pad = "// MUDULE : $pad_ring_name\n".$pad_ring_name.$tab.$pad_ring_name." \(\n\n";
	while (<PRV>) {
		if (/\s*input\s+(?:\S+)?\s+(\S+)\s*;\s*/) {
			push @pad_ring_list, $1;
			#$i++;
		}
		elsif (/\s*output\s+(?:\S+)?\s+(\S+)\s*;\s*/) {
			push @pad_ring_list, $1;
			#$i++;
		}
		elsif (/\s*inout\s+(?:\S+)?\s+(\S+)\s*;\s*/) {
			push @pad_ring_list, $1;
			#$i++;
		} 
	}
	foreach my $temp_pad (@pad_ring_list) {
		if ($temp_pad eq $pad_ring_list[-1]) {
			$chip_pad .= sprintf("%-5s\.%-24s\(%-23s\)\n", $tab,$temp_pad,$temp_pad);
		}
		else {
			$chip_pad .= sprintf("%-5s\.%-24s\(%-23s\),\n", $tab,$temp_pad,$temp_pad);
		}
	}
	$chip_pad .= $tab."\);\n\n";
	#print "$chip_pad\n";
	#print "$i\n";
}


sub inst_soc_core() {
	my $soc_core_list;
	$chip_core = "// MODULE : sco_core\n"."soc_core".$tab."soc_core\(\n\n";
	#my $i = 0;
	open (SCV, "<", $core_ports) or die "[Info] : $!\n";
	while (<SCV>) {
		if (/\s*input\s+(?:\S+)?\s+(\S+)\s*/) {
			push @soc_core_list, $1;
		}
		elsif (/\s*output\s+(?:\S+)?\s+(\S+)\s*/) {
			push @soc_core_list, $1;
		}
		elsif (/\s*inout\s+(?:\S+)?\s+(\S+)\s+(\S+)\s+(\S+)\s*/) {
			push @soc_core_list, $1;
			push @soc_core_list, $2;
			push @soc_core_list, $3;
		}
	}
	foreach my $temp_core (@soc_core_list) {
		my $port_wire = $temp_core."_wire";
		if ($temp_core eq $soc_core_list[-1]) {
			$chip_core .= sprintf ("%-5s\.%-24s\(%-24s\)\n", $tab, $temp_core, $port_wire);
		}
		else {
			$chip_core .= sprintf ("%-5s\.%-24s\(%-24s\),\n", $tab, $temp_core, $port_wire);
		}
	}
	$chip_core .= $tab."\);\n";
	#print "$chip_core\n";
	#print "$i\n";
}


sub gen_soc_chip() {
	my $soc_chip = $chip_top.$chip_list.$chip_wire.$chip_pad.$chip_core."\nendmodule\n";
	$chip_name .= "\.v";
	open (CHIP, ">", $chip_name) or die "$!\n";
	print CHIP $soc_chip;
	print "SUCCESSFULY GENERATED SOC_CHIP!!!\n";
}
