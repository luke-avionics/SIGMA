#!/usr/bin/perl

##Read the Verilog model

open SOURCE, "<$ARGV[0]" or print "Usage: ETF.pl <Verilog file>\n";

@filedata=<SOURCE>;
close SOURCE;
$file= $ARGV[0]."."."modified";
open DEST, ">$file";

%seen=(); ## need this to uniquify conditions
@uniq=(); ## need this to uniquify conditions
%index=(); ## index the conditions and suffix this index to delayed signals
%mux=();
@modified_content=();
$line_no=0;
foreach $line (@filedata) {
     $line_no++;
    if($line =~ /\bspecify\b/) {
       $being_modified =1; #flag to indicate the lines are modified.
        $end_of_specify =0; #reset this flag - some files have multiple modules
        %mux=();
        %seen=();
        $end_of_module=0;
}
    if(($line =~ /\$setup/) || ($line =~ /\$rec/)|| ($line =~ /\$hold/)) { ## check if the line has timing check construct
       if($line =~ /(\&\&\&)(\s+)(.*?),/) { ## check for  timing check conditions
   #print "$line\n";
           $condition =$3;
        unless ($seen{$condition}) {
            $seen{$condition} =1;
            push(@uniq,$condition); ## create a list of conditions seen in timing checks

}
my ($index) =grep {$uniq[$_] eq $condition} 0..$#uniq; 
  if( $line =~ /,(\s*),(\s*),(\s*)(\w+),(\s*)(\w+)/) {
      $line=~ s/,(\s*),(\s*),(\s*)(\w+),(\s*)(\w+)/,$1,$2,$4_$index,$6_$index/;
           $orig_delayed_clk= "$4";
           $orig_delayed_sig ="$6";

           $delayed_clk = "$4_$index";
           $delayed_data = "$6_$index";
  unless ($seen{$orig_delayed_clk}) {
               $seen{$orig_delayed_clk}=1;
        ##$mux_line = "assign $orig_delayed_clk= $condition ? $delayed_clk:"; 
        $mux{$orig_delayed_clk} = "assign $orig_delayed_clk= \( $condition \) ? $delayed_clk:"; 
               $orig_delayed_clk =~ s/d_(.*)/$1/;
              $default_clk = $orig_delayed_clk; $default_clk =~ s/_d//;
       print "The default clk is $default_clk \n";
    $prev_index=$index;
}
elsif($prev_index != $index) {
       $mux{$orig_delayed_clk}.= "\($condition\) ? $delayed_clk:";
        $prev_index=$index;
}

unless ($seen{$orig_delayed_sig}) {
               $seen{$orig_delayed_sig}=1;
        $mux{$orig_delayed_sig} = "assign $orig_delayed_sig= \($condition\) ? $delayed_data:"; 
               $orig_delayed_sig =~ s/d_(.*)/$1/;
              $default_sig=$orig_delayed_sig;$default_sig =~ s/_d//;
    $prev_data_index=$index;
}
elsif($prev_data_index != $index) {
       $mux{$orig_delayed_sig}.= "\($condition\) ? $delayed_data:";
        $prev_data_index=$index;
}

        unless ($seen{$delayed_clk}) {
            $seen{$delayed_clk} =1;
      push (@added_lines, "wire $delayed_clk;\n"); 
       }
       unless ($seen{$delayed_data}) {
          $seen{$delayed_data}=1;
      push (@added_lines, "wire $delayed_data;\n"); 
}
    push(@modified_lines, $line);
  
}
else { ## no delayed clock or signals
  push(@modified_lines, $line);
}
#print "the index of $condition is $index\n";
#print "the condition is $condition\n";
}
else {
push(@modified_lines, $line);
}
} ##closing brace for if($line =~/\$(setup ||re)/) ...
elsif($line=~/endspecify/) {
  $end_of_specify =1;
   $being_modified =0;
   push(@modified_lines, $line);
    foreach $item (sort keys %mux) {
    push(@after_specify, $mux{$item});
     $item =~ s/d_(.*)/$1/;
     $item =~ s/_d//;
    push(@after_specify, "$item;\n");
}
}
elsif($being_modified) {
push(@modified_lines,$line);
}
elsif ($end_of_module ) {
     if($line_no==$#filedata+1) {
       push(@modified_content, $line);
        print "End of File reached\n";
        $end_of_module=0;
     }
     else {
       push(@modified_content, $line);
        }
}
elsif(!$being_modified && !$end_of_specify){
push(@before_specify, $line);## print rest of the lines
}

elsif($line =~/endmodule/) {
    $end_of_specify = 0 ;
   @modified_content =(@modified_content, @before_specify, @added_lines, @modified_lines, @after_specify,$line);
    @before_specify =(); @added_lines=();@modified_lines=();@after_specify=();
    $end_of_module = 1;
}
elsif($end_of_specify) {
   push(@after_specify, $line);
}
} ##end of foreach $line ...
print DEST @modified_content;
#print DEST @before_specify; 
#print DEST @added_lines; 
#print DEST @modified_lines;
#print DEST @after_specify;

foreach $it (@uniq) {
print "unique conditions are $it\n";
}

#print @modified_lines;
