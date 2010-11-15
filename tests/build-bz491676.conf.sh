./ccs -f test --createcluster rh5single
./ccs -f test --setfencedaemon clean_start="0" post_fail_delay="0" post_join_delay="50"
./ccs -f test --setlogging to_stderr="yes"
./ccs -f test --addlogger ident="CPG" debug="on"
./ccs -f test --addlogger ident="CMAN" debug="on"

./ccs -f test --addnode rh5node-single.examplerh.com
./ccs -f test --addmethod 1 rh5node-single.examplerh.com

./ccs -f test --addfencedev xvm agent="fence_xvm"

./ccs -f test --addfenceinst xvm rh5node-single.examplerh.com 1 domain="rh5node_single"

./ccs -f test --setmulticast 239.1.1.1

./ccs -f test --setrm log_facility="local4" log_level="7"

./ccs -f test --addservice foo
./ccs -f test --addsubservice foo ip address="1.2.3.4" sleeptime="10"

./ccs -f test --settotem consensus="400"
