#!/usr/bin/perl -w

$CCS = "../ccs";

if (add_remove_test("addtest.conf") == 0) {
  print "Add/Remove Node Test Succeeded\n";
}

if (ls_nodes_test("lsnodes.conf") == 0) {
  print "List Node Test Succeeded\n";
}

if (version_test("version.conf") == 0) {
  print "Version Test Succeeded\n";
}

if (fence_test("fence.conf") == 0) {
  print "Fence Test Succeeded\n";
}

if (failover_test("failover.conf") == 0) {
  print "Failover Test Succeeded\n";
}

if (service_test("service.conf") == 0) {
  print "Service Test Succeeded\n";
}

if (quorum_test("quorum.conf") == 0) {
  print "Quorum Test Succeeded\n";
}

if (misc_test("misc.conf") == 0) {
  print "Misc Test Succeeded\n";
}

#if (expmode_test("exp.conf") == 0) {
#  print "Expert Mode Test Succeeded\n";
#}

sub expmode_test {
  $t = shift @_;
  test ("$CCS -f $t --createcluster mycluster",0);
  test ("$CCS -f $t --exp fence_daemon cluster",0);
}

sub misc_test {
  $t = shift @_;
  test ("$CCS -f $t --createcluster mycluster",0);
  test ("$CCS -f $t --addnode node1",0);
  test ("$CCS -f $t --addnode node2",0);

  test ("$CCS -f $t --settotem a=b b=c",0);
  test ("$CCS -f $t --settotem x=y z=c",0);

  test ("$CCS -f $t --setrm a=b b=c",0);
  test ("$CCS -f $t --setrm x=y z=c",0);

  test ("$CCS -f $t --setmulticast 53",0);

  test ("$CCS -f $t --setcman a=b b=c",0);
  test ("$CCS -f $t --setcman x=y z=c",0);

  test ("$CCS -f $t --setdlm a=b b=c",0);
  test ("$CCS -f $t --setdlm x=y z=c",0);

  test ("$CCS -f $t --setmulticast 55",0);
  test ("$CCS -f $t --setmulticast 57",0);
  test ("$CCS -f $t --setmulticast",0);
  test ("$CCS -f $t --setmulticast 55",0);
  test ("$CCS -f $t --setmulticast 56",0);

  test ("$CCS -f $t --setfencedaemon a=b b=c",0);
  test ("$CCS -f $t --setfencedaemon x=y z=c",0);

  test ("$CCS -f $t --setlogging a=b b=c",0);
  test ("$CCS -f $t --setlogging x=y z=c",0);

  test ("$CCS -f $t --addlogger mylog=1",0);
  test ("$CCS -f $t --addlogger mylog=2",0);
  test ("$CCS -f $t --addlogger mylog=3",0);
  test ("$CCS -f $t --addlogger mylog=4",0);
  test ("$CCS -f $t --addlogger mylog=5",0);

  test ("$CCS -f $t --rmlogger mylog=4",0);
  test ("$CCS -f $t --rmlogger mylog=4",1);

  $retval = diff ($t,"$t.end");
  #`rm $t`;
  return $retval;
}

sub quorum_test {
  $t = shift @_;
  test ("$CCS -f $t --createcluster mycluster",0);
  test ("$CCS -f $t --addnode node1",0);
  test ("$CCS -f $t --addnode node2",0);
  test ("$CCS -f $t --addheuristic options=TTT",0);
  test ("$CCS -f $t --setquorumd options=XXX",0);
  test ("$CCS -f $t --addheuristic options=YYY",0);
  test ("$CCS -f $t --setquorumd options=AAA",0);
  test ("$CCS -f $t --addheuristic options=BBB",0);
  test ("$CCS -f $t --addheuristic options=CCC",0);

  test ("$CCS -f $t --rmheuristic options=TTT",0);
  test ("$CCS -f $t --rmheuristic options=TTT",1);
  test ("$CCS -f $t --rmheuristic options=BBB",0);

  $retval = diff ($t,"$t.end");
  #`rm $t`;
  return $retval;
}

sub service_test {
  $t = shift @_;
  test ("$CCS -f $t --createcluster mycluster",0);
  test ("$CCS -f $t --addnode node1",0);
  test ("$CCS -f $t --addnode node2",0);
  test ("$CCS -f $t --addservice service1",0);
  test ("$CCS -f $t --addservice service2 a=b c=d",0);
  test ("$CCS -f $t --addservice service2 a=b c=d",1);
  test ("$CCS -f $t --addservice service2",1);
  test ("$CCS -f $t --addservice service3 a=b c=d",0);
  test ("$CCS -f $t --rmservice service3",0);
  test ("$CCS -f $t --addsubservice service1 nfs a=b c=1",0);
  test ("$CCS -f $t --addsubservice service2 nfs a=b c=2",0);
  test ("$CCS -f $t --addsubservice service2 nfs:nfs a=b c=3",0);
  test ("$CCS -f $t --addsubservice service2 nfs:nfs a=b c=4",0);
  test ("$CCS -f $t --addsubservice service2 nfs:nfs[0]:nfs a=b c=5",0);
  test ("$CCS -f $t --addsubservice service2 nfs:nfs[1]:nfs a=b c=6",0);
  test ("$CCS -f $t --addsubservice service2 nfs:nfs[1]:nfs a=b c=6.1",0);
  test ("$CCS -f $t --addsubservice service2 nfs a=b c=7",0);
  test ("$CCS -f $t --addsubservice service2 nfs:nfs[1]:nfs:nfs a=b c=8",0);
  test ("$CCS -f $t --addsubservice service2 nfs:nfs[1]:nfs:nfs a=b c=9",0);
  test ("$CCS -f $t --addsubservice service2 nfs:nfs[1]:nfs:nfs[1]:deep a=b c=11",0);
  test ("$CCS -f $t --addsubservice service2 nfs:nfs[1]:nfs[1]:nfs a=b c=10",0);
  test ("$CCS -f $t --addsubservice service2 nfs:nfs[1]:nfs[1]:nfs a=b c=12",0);
  test ("$CCS -f $t --addsubservice service2 nfs:nfs[1]:nfs[1]:nfs a=b c=13",0);
  test ("$CCS -f $t --addsubservice service2 nfs:nfs[0]:nfs a=b c=14",0);
  test ("$CCS -f $t --addsubservice service2 nfs:nfs[0]:nfs[1]:nfs a=b c=15",0);
  test ("$CCS -f $t --addsubservice service2 nfs a=b c=7",0);
  test ("$CCS -f $t --addsubservice service2 nfs[1]:nfs a=b c=16",0);
  test ("$CCS -f $t --addsubservice service2 nfs[2]:nfs a=b c=17",0);

  test ("$CCS -f $t --rmsubservice service2 nfs:nfs[1]:nfs[1]:nfs[1]",0);
  test ("$CCS -f $t --rmsubservice service2 nfs[2]:nfs",0);
  test ("$CCS -f $t --rmsubservice service2 nfs[2]:nfs",1);

  test ("$CCS -f $t --addresource restype1 a=b b=1",0);
  test ("$CCS -f $t --addresource restype2 a=b b=2",0);
  test ("$CCS -f $t --addresource restype3 a=b b=3",0);
  test ("$CCS -f $t --addresource restype3 a=b b=4",0);
  test ("$CCS -f $t --addresource restype3 a=b b=5",0);
  test ("$CCS -f $t --addresource restype3 a=b b=6",0);

  test ("$CCS -f $t --rmresource restype3 a=b b=3",0);
  test ("$CCS -f $t --rmresource restype3 a=b b=5",0);


  $retval = diff ($t,"$t.end");
  #`rm $t`;
  return $retval;
}



sub failover_test {
  $t = shift @_;
  test ("$CCS -f $t --createcluster mycluster",0);
  test ("$CCS -f $t --addnode node1",0);
  test ("$CCS -f $t --addnode node2",0);
  test ("$CCS -f $t --addfailoverdomain fd1 restricted ordered nofailback",0);
  test ("$CCS -f $t --addfailoverdomain fd2 restricted ordered ",0);
  test ("$CCS -f $t --addfailoverdomain fd3 restricted nofailback",0);
  test ("$CCS -f $t --addfailoverdomain fd4 ordered nofailback",0);
  test ("$CCS -f $t --addfailoverdomain fd5 restricted",0);
  test ("$CCS -f $t --addfailoverdomain fd6 ordered",0);
  test ("$CCS -f $t --addfailoverdomain fd7 nofailback",0);
  test ("$CCS -f $t --addfailoverdomain fd8 nofailback",0);
  test ("$CCS -f $t --addfailoverdomain fd9 restricted",0);
  test ("$CCS -f $t --addfailoverdomain fd9",1);
  test ("$CCS -f $t --rmfailoverdomain fd8",0);
  test ("$CCS -f $t --rmfailoverdomain fd8",1);
  test ("$CCS -f $t --addfailoverdomainnode fd1 node1",0);
  test ("$CCS -f $t --addfailoverdomainnode fd1 node1",0);
  test ("$CCS -f $t --addfailoverdomainnode fd2 node1",0);
  test ("$CCS -f $t --addfailoverdomainnode fd3 node2 priority=50",2);
  test ("$CCS -f $t --addfailoverdomainnode fd3 node2 50",0);
  test ("$CCS -f $t --addfailoverdomainnode fd3 node2 51",0);
  test ("$CCS -f $t --addfailoverdomainnode fd4 node2 50",0);
  test ("$CCS -f $t --addfailoverdomainnode fd4 node1 0",2);
  test ("$CCS -f $t --addfailoverdomainnode fd4 node1 101",2);
  test ("$CCS -f $t --addfailoverdomainnode fd4 node1 1",0);
  test ("$CCS -f $t --addfailoverdomainnode fd5 node2 50",0);
  test ("$CCS -f $t --addfailoverdomainnode fd5 node1 1",0);
  test ("$CCS -f $t --rmfailoverdomainnode fd5 node1",0);
  test ("$CCS -f $t --rmfailoverdomainnode fd5 node1",1);
  test ("$CCS -f $t --rmfailoverdomainnode fd5 node2",0);

  $retval = diff ($t,"$t.end");
  #`rm $t`;
  return $retval;
}


sub fence_test {
  $t = shift @_;
  test ("$CCS -f $t --createcluster mycluster",0);
  test ("$CCS -f $t --addnode node1",0);
  test ("$CCS -f $t --addnode node2",0);
  test ("$CCS -f $t --addmethod badmethod node3",1);
  test ("$CCS -f $t --addmethod node1method node1",0);
  test ("$CCS -f $t --addmethod node2method node2",0);
  test ("$CCS -f $t --addmethod node1method2 node1",0);
  test ("$CCS -f $t --addmethod node2method2 node2",0);
  test ("$CCS -f $t --addmethod node1method3 node1",0);
  test ("$CCS -f $t --addmethod node2method3 node2",0);
  test ("$CCS -f $t --rmmethod node1method3 node1",0);
  test ("$CCS -f $t --rmmethod node1methodX node1",1);
  test ("$CCS -f $t --addfencedev fence_ilo agent=fence_ilo optiona=x optionb=y",0);
  test ("$CCS -f $t --addfencedev fence_apc agent=fence_apc optiona=x optionb=y",0);
  test ("$CCS -f $t --addfencedev fence_apc2 agent=fence_apc optiona=x optionb=y",0);
  test ("$CCS -f $t --addfencedev fence_apcX agent=fence_apc optiona=x optionb=y",0);
  test ("$CCS -f $t --rmfencedev fence_apcX",0);
  test ("$CCS -f $t --rmfencedev fence_apcX",1);
  test ("$CCS -f $t --addfenceinst fence_apcX node1 node1method",1);
  test ("$CCS -f $t --addfenceinst fence_ilo node1 node1method port=5",0);
  test ("$CCS -f $t --addfenceinst fence_ilo node1 node1method port=6",0);
  test ("$CCS -f $t --addfenceinst fence_apc node1 node1method port=1",0);
  test ("$CCS -f $t --addfenceinst fence_apc node1 badmethod port=1",1);
  test ("$CCS -f $t --rmfenceinst fence_ilo node1 node1method",0);
  test ("$CCS -f $t --rmfenceinst fence_ilo node1 node1method",1);
  test ("$CCS -f $t --rmunfenceinst fence_ilo node1 node1method",1);
  test ("$CCS -f $t --addunfenceinst myilo node1 port=10",0);
  test ("$CCS -f $t --addunfenceinst myilo node1 port=11",0);
  test ("$CCS -f $t --addunfenceinst myapc node1 port=12",0);
  test ("$CCS -f $t --addunfenceinst myapc nodeX port=12",1);
  test ("$CCS -f $t --rmunfenceinst myapc nodeX",1);
  test ("$CCS -f $t --rmunfenceinst myilo nodeX",1);
  test ("$CCS -f $t --rmunfenceinst myapc node1",0);
  test ("$CCS -f $t --rmunfenceinst myilo node1",0);
  test ("$CCS -f $t --addunfenceinst myilo node1 port=15",0);
  test ("$CCS -f $t --addunfenceinst myilo node1 port=16",0);
  test ("$CCS -f $t --addunfenceinst myapc node1 port=17",0);

  $retval = diff ($t,"$t.end");
  #`rm $t`;
  return $retval;
}

sub version_test {
  $t = shift @_;
  test ("$CCS -f $t --createcluster mycluster",0);
  test ("$CCS -f $t --setversion 50",0);
  test ("$CCS -f $t --incversion",0);
  $retval =  getoutput ("$CCS -f $t --getversion","$t.end");
}
  


sub ls_nodes_test {
  $t = shift @_;
  test ("$CCS -f $t --createcluster mycluster",0);
  test ("$CCS -f $t --addnode node1",0);
  test ("$CCS -f $t --addnode node2",0);
  $retval =  getoutput ("$CCS -f $t --lsnodes","$t.end");
  #`rm $t`;
  return $retval;
}


sub add_remove_test {
  $t = shift @_;
  test ("$CCS -f $t --createcluster mycluster",0);

# Add nodes including duplicates

  test ("$CCS -f $t --addnode node1",0);
  test ("$CCS -f $t --addnode node2",0);
  test ("$CCS -f $t --addnode node3",0);
  test ("$CCS -f $t --addnode node4",0);
  test ("$CCS -f $t --addnode node5",0);
  test ("$CCS -f $t --addnode node5",1);
  test ("$CCS -f $t --addnode node6",0);
  test ("$CCS -f $t --addnode node5",1);
  test ("$CCS -f $t --addnode node7",0);
  test ("$CCS -f $t --addnode node8",0);
  test ("$CCS -f $t --addnode node9",0);

# Remove nodes (including onces that don't exist)
  test ("$CCS -f $t --rmnode node1",0);
  test ("$CCS -f $t --rmnode node1",1);
  test ("$CCS -f $t --rmnode xxxx",1);
  test ("$CCS -f $t --rmnode node2",0);
  test ("$CCS -f $t --rmnode node3",0);
  test ("$CCS -f $t --rmnode node4",0);
  test ("$CCS -f $t --rmnode node5",0);
  test ("$CCS -f $t --rmnode node6",0);
  test ("$CCS -f $t --rmnode node7",0);
  test ("$CCS -f $t --rmnode node8",0);
  test ("$CCS -f $t --rmnode node9",0);

# Re-add all the nodes again
  test ("$CCS -f $t --addnode node1",0);
  test ("$CCS -f $t --addnode node2",0);
  test ("$CCS -f $t --addnode node3",0);
  test ("$CCS -f $t --addnode node4",0);
  test ("$CCS -f $t --addnode node5",0);
  test ("$CCS -f $t --addnode node6",0);
  test ("$CCS -f $t --addnode node7",0);
  test ("$CCS -f $t --addnode node8",0);

# Set nodeid's
  test ("$CCS -f $t --addnode node9 --nodeid 6",1);
  test ("$CCS -f $t --addnode node1",1);
  test ("$CCS -f $t --addnode node2 --nodeid 5",1);
  test ("$CCS -f $t --addnode node20 --nodeid 5",1);
  test ("$CCS -f $t --addnode node3",1);
  test ("$CCS -f $t --addnode node10 --nodeid 60",0);
  test ("$CCS -f $t --addnode node10 --nodeid 61",1);
  test ("$CCS -f $t --addnode node4 --nodeid 7",1);
  test ("$CCS -f $t --addnode node11",0);

# Set votes
  test ("$CCS -f $t --addnode node11 --votes 5",1);
  test ("$CCS -f $t --addnode node12 --votes 4",0);
  test ("$CCS -f $t --addnode node13 --votes b",0);
  test ("$CCS -f $t --addnode node14 --nodeid 14 --votes 1",0);

  $retval = diff ($t,"$t.end");
  #`rm $t`;
  return $retval;
}


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
    return 1;
  }
  return 0;
}

sub diff {
  my ($new,$orig) = @_;
  return test("diff -u $new $orig",0,1);
}

# Run a program and compare its output (including stderr) to a file
# Return 0 if they match, 1 if they don't return 0 and print a diff
sub getoutput {
  my ($command, $filename) = @_;
  `$command 2>&1 > $filename.out`;
  $retval = diff ($filename, "$filename.out");
  `rm $filename.out`;
  return $retval;
}
