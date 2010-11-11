./ccs -f test --createcluster rh5single
./ccs -f test --setfencedaemon clean_start="0" post_fail_delay="0" post_join_delay="50" override_path="/tmp/foo"
./ccs -f test --addnode rh5node-single.examplerh.com
./ccs -f test --settotem consensus="400"
./ccs -f test --setrm log_facility="local4" log_level="7"
