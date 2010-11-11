./ccs -f test --createcluster rh5single
./ccs -f test --setfencedaemon post_fail_delay="0" clean_start="0" post_join_delay="50"
./ccs -f test --addnode rh5node-single.examplerh.com
./ccs -f test --setrm log_facility="local4" log_level="7"
./ccs -f test --addservice foo
./ccs -f test --addsubservice foo vm autostart="1" domain="bias-satxen1" exclusive="0" migrate="live" name="razorback" path="/guest_roots" recovery="restart"
./ccs -f test --settotem consensus="400"
./ccs -f test --addfencedev bc agent="fence_bladecenter" ipaddr="1.2.3.4" login="login" passwd="pwd" secure="1"
./ccs -f test --addmethod 1 rh5node-single.examplerh.com
./ccs -f test --addfenceinst bc rh5node-single.examplerh.com 1
