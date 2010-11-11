./ccs -f test --createcluster rh5single
./ccs -f test --setfencedaemon post_fail_delay="0" clean_start="0" post_join_delay="50"
./ccs -f test --addnode rh5node-single.examplerh.com
./ccs -f test --setrm log_facility="local4" log_level="7"
./ccs -f test --addresource script file="/etc/init.d/httpd" name="httpd"
./ccs -f test --addservice foo
./ccs -f test --addsubservice foo ip address="1.2.3.4" sleeptime="10" __independent_subtree="1"
./ccs -f test --addsubservice foo script ref="httpd" __independent_subtree="1"
./ccs -f test --settotem consensus="400"
