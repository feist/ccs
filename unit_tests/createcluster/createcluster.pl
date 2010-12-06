#!/usr/bin/perl -w
print $ARGV[0];
exit;
$CCS = "../../ccs";

test ("$CCS -f addtest.conf --createcluster mycluster",0);

# Add nodes including duplicates

test ("$CCS -f addtest.conf --addnode node1",0);
test ("$CCS -f addtest.conf --addnode node2",0);
test ("$CCS -f addtest.conf --addnode node3",0);
test ("$CCS -f addtest.conf --addnode node4",0);
test ("$CCS -f addtest.conf --addnode node5",0);
test ("$CCS -f addtest.conf --addnode node5",1);
test ("$CCS -f addtest.conf --addnode node6",0);
test ("$CCS -f addtest.conf --addnode node5",1);
test ("$CCS -f addtest.conf --addnode node7",0);
test ("$CCS -f addtest.conf --addnode node8",0);

# Remove nodes (including onces that don't exist)
test ("$CCS -f addtest.conf --removenode node1",0);
test ("$CCS -f addtest.conf --removenode node1",1);
test ("$CCS -f addtest.conf --removenode xxxx",1);
test ("$CCS -f addtest.conf --removenode node2",0);
test ("$CCS -f addtest.conf --removenode node3",0);
test ("$CCS -f addtest.conf --removenode node4",0);
test ("$CCS -f addtest.conf --removenode node5",0);
test ("$CCS -f addtest.conf --removenode node6",0);
test ("$CCS -f addtest.conf --removenode node7",0);
test ("$CCS -f addtest.conf --removenode node8",0);

# Re-add all the nodes again
test ("$CCS -f addtest.conf --addnode node1",0);
test ("$CCS -f addtest.conf --addnode node2",0);
test ("$CCS -f addtest.conf --addnode node3",0);
test ("$CCS -f addtest.conf --addnode node4",0);
test ("$CCS -f addtest.conf --addnode node5",0);
test ("$CCS -f addtest.conf --addnode node6",0);
test ("$CCS -f addtest.conf --addnode node7",0);
test ("$CCS -f addtest.conf --addnode node8",0);
diff ("addtest.conf","addtest.conf.end");

#diff addtest.conf addtest.conf.end

sub test {
  my ($command, $expectedreturn, $printoutput) = @_;
  if (defined($printoutput)) {
    system($command);
  } else {
    system($command . " > /dev/null");
  }

  $output = $? >> 8;
  if ($output != $expectedreturn) {
    print "Error: $command returned $output, not $expectedreturn\n";
  }
}

sub diff {
  my ($new,$orig) = @_;
  test("diff -u $new $orig",0,1);
}
