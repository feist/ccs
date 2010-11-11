#!/usr/bin/perl -w

$CONFIGFILE_DIR = "conf_tests/";
$TESTS_DIR = "tests/";
$XMLDIFF = "./xmldiff.py";

@TESTS = glob("$TESTS_DIR*.sh");

foreach $test (@TESTS) {
  $orig_config = $test;
  $orig_config =~ s/^${TESTS_DIR}build-//;
  $orig_config =~ s/.sh$//;
  $orig_config = $CONFIGFILE_DIR . $orig_config;
  print $test . "-" . $orig_config . "\n";
  `sh $test`;
  print "$XMLDIFF test $orig_config\n";
  print `$XMLDIFF test $orig_config`;
#  sleep(5);
}
