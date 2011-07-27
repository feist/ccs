#!/usr/bin/perl -w

$CCS = "../ccs";

if (add_remove_test("addtest.conf") == 0) {
  print "Add/Remove Node Test Succeeded\n";
} else {
  print "Add/Remove Node Test FAILED\n";
  exit 0;
}

if (ls_nodes_test("lsnodes.conf") == 0) {
  print "List Node Test Succeeded\n";
} else {
  print "List Node Test FAILED\n";
  exit 0;
}

if (version_test("version.conf") == 0) {
  print "Version Test Succeeded\n";
} else {
  print "Version Test FAILED\n";
  exit 0;
}

if (fence_test("fence.conf") == 0) {
  print "Fence Test Succeeded\n";
} else {
  print "Fence Test FAILED\n";
  exit 0;
}

if (failover_test("failover.conf") == 0) {
  print "Failover Test Succeeded\n";
} else {
  print "Failover Test FAILED\n";
  exit 0;
}

if (service_test("service.conf") == 0) {
  print "Service Test Succeeded\n";
} else {
  print "Service Test FAILED\n";
  exit 0;
}

if (quorum_test("quorum.conf") == 0) {
  print "Quorum Test Succeeded\n";
} else {
  print "Quorum Test FAILED\n";
  exit 0;
}


if (misc_test("misc.conf") == 0) {
  print "Misc Test Succeeded\n";
} else {
  print "Misc Test FAILED\n";
  exit 0;
}

#if (expmode_test("exp.conf") == 0) {
#  print "Expert Mode Test Succeeded\n";
# else {
#  print "Expert Mode Test FAILED\n";
#exit 0;
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

  test ("$CCS -f $t --settotem join=b token=c",0);
  test ("$CCS -f $t --settotem join=y token=c",0);

  test ("$CCS -f $t --setrm log_level=4",0);
  test ("$CCS -f $t --setrm log_level=5",0);

  test ("$CCS -f $t --setmulticast 1.1.1.1",0);

  test ("$CCS -f $t --setcman two_node=1 expected_votes=5",0);
  test ("$CCS -f $t --setcman two_node=2 expected_votes=9",0);

  test ("$CCS -f $t --setdlm log_debug=1",0);
  test ("$CCS -f $t --setdlm timewarn=4 enable_fencing=1",0);

  test ("$CCS -f $t --setmulticast 55",0);
  test ("$CCS -f $t --setmulticast 57",0);
  test ("$CCS -f $t --setmulticast",0);
  test ("$CCS -f $t --setmulticast 55",0);
  test ("$CCS -f $t --setmulticast 56",0);

  test ("$CCS -f $t --setfencedaemon post_join_delay=b override_path=c",0);
  test ("$CCS -f $t --setfencedaemon post_fail_delay=y override_time=c",0);

  test ("$CCS -f $t --setlogging to_syslog=b to_logfile=c",0);
  test ("$CCS -f $t --setlogging syslog_facility=y syslog_priority=c",0);

  test ("$CCS -f $t --addlogging name=1 to_logfile=1",0);
  test ("$CCS -f $t --addlogging name=2 loc=2",1);
  test ("$CCS -f $t --addlogging name=3 to_logfile=3",0);
  test ("$CCS -f $t --addlogging name=4 to_logfile=4",0);
  test ("$CCS -f $t --addlogging name=5 to_logfile=5",0);

  test ("$CCS -f $t --rmlogging name=4",0);
  test ("$CCS -f $t --rmlogging name=4",1);

  $retval = diff ($t,"$t.end");
  #`rm $t`;
  return $retval;
}

sub quorum_test {
  $t = shift @_;
  test ("$CCS -f $t --createcluster mycluster",0);
  test ("$CCS -f $t --addnode node1",0);
  test ("$CCS -f $t --addnode node2",0);
  test ("$CCS -f $t --addheuristic program=TTT",0);
  test ("$CCS -f $t --setquorumd device=XXX",0);
  test ("$CCS -f $t --addheuristic program=YYY",0);
  test ("$CCS -f $t --setquorumd device=AAA",0);
  test ("$CCS -f $t --addheuristic program=BBB",0);
  test ("$CCS -f $t --addheuristic program=CCC",0);

  test ("$CCS -f $t --rmheuristic program=TTT",0);
  test ("$CCS -f $t --rmheuristic program=TTT",1);
  test ("$CCS -f $t --rmheuristic program=BBB",0);

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
  test ("$CCS -f $t --addservice service2 domain=mydomain exclusive=1",0);
  test ("$CCS -f $t --addservice service2 domain=mydomain exclusive=1",1);
  test ("$CCS -f $t --addservice service2",1);
  test ("$CCS -f $t --addservice service3 domain=mydomain2 exclusive=0",0);
  test ("$CCS -f $t --rmservice service3",0);
  test ("$CCS -f $t --addsubservice service1 nfsclient name=clientname target=host1 path=/mypath",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient name=clientname2 target=host2 path=/mypath2",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient:nfsclient name=b target=3",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient:nfsclient name=b target=4",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient:nfsclient[0]:nfsclient name=b target=5",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient:nfsclient[1]:nfsclient name=b target=6",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient:nfsclient[1]:nfsclient name=b target=6.1",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient name=b target=7",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient:nfsclient[1]:nfsclient:nfsclient name=b target=8",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient:nfsclient[1]:nfsclient:nfsclient name=b target=9",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient:nfsclient[1]:nfsclient:nfsclient[1]:nfsexport name=b device=11",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient:nfsclient[1]:nfsclient[1]:nfsclient name=b target=10",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient:nfsclient[1]:nfsclient[1]:nfsclient name=b target=12",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient:nfsclient[1]:nfsclient[1]:nfsclient name=b target=13",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient:nfsclient[0]:nfsclient name=b target=14",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient:nfsclient[0]:nfsclient[1]:nfsclient name=b target=15",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient name=b target=7",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient[1]:nfsclient name=b target=16",0);
  test ("$CCS -f $t --addsubservice service2 nfsclient[2]:nfsclient name=b target=17",0);

  test ("$CCS -f $t --rmsubservice service2 nfsclient:nfsclient[1]:nfsclient[1]:nfsclient[1]",0);
  test ("$CCS -f $t --rmsubservice service2 nfsclient[2]:nfsclient",0);
  test ("$CCS -f $t --rmsubservice service2 nfsclient[2]:nfsclient",1);

  test ("$CCS -f $t --addresource nfsexport name=b",0);
  test ("$CCS -f $t --addresource nfsexport name=b",1);
  test ("$CCS -f $t --addresource ip address=3",0);
  test ("$CCS -f $t --addresource ip address=4",0);
  test ("$CCS -f $t --addresource ip address=5",0);
  test ("$CCS -f $t --addresource ip address=6",0);

  test ("$CCS -f $t --rmresource ip address=3",0);
  test ("$CCS -f $t --rmresource ip address=5",0);

  test ("$CCS -f $t --addvm vmname1 a=b",1);
  test ("$CCS -f $t --addvm vmname1 autostart=0 migrate=live",0);
  test ("$CCS -f $t --addvm vmname2 autostart=1 migrate=live",0);
  test ("$CCS -f $t --addvm vmname3 autostart=0 migrate=live",0);
  test ("$CCS -f $t --addvm vmname1 autostart=0 migrate=live",1);
  test ("$CCS -f $t --rmvm vmname1",0);
  test ("$CCS -f $t --addvm vmname1 autostart=1 migrate=live",0);


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
  test ("$CCS -f $t --addfencedev fence_ilo agent=fence_ilo ipaddr=1.1.1.1 login=login passwd=password",0);
  test ("$CCS -f $t --addfencedev fence_apc agent=fence_apc ipaddr=2.2.2.2 login=login2 passwd=password2",0);
  test ("$CCS -f $t --addfencedev fence_apc2 agent=fence_apc ipaddr=3.3.3.3 login=login3 passwd=password3",0);
  test ("$CCS -f $t --addfencedev fence_apcX agent=fence_apc ipaddr=4.4.4.4 login=login4 passwd=password4",0);
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
  test ("$CCS -f $t --addunfenceinst fence_ilo node1 port=10",0);
  test ("$CCS -f $t --addunfenceinst fence_ilo node1 port=11",0);
  test ("$CCS -f $t --addunfenceinst fence_apc node1 port=12",0);
  test ("$CCS -f $t --addunfenceinst fence_apc nodeX port=12",1);
  test ("$CCS -f $t --rmunfenceinst fence_apc nodeX",1);
  test ("$CCS -f $t --rmunfenceinst fence_ilo nodeX",1);
  test ("$CCS -f $t --rmunfenceinst fence_apc node1",0);
  test ("$CCS -f $t --rmunfenceinst fence_ilo node1",0);
  test ("$CCS -f $t --addunfenceinst fence_ilo node1 port=15",0);
  test ("$CCS -f $t --addunfenceinst fence_ilo node1 port=16",0);
  test ("$CCS -f $t --addunfenceinst fence_apc node1 port=17",0);

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
