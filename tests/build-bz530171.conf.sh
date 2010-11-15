./ccs -f test --createcluster rh5single
./ccs -f test --setfencedaemon clean_start="0" post_fail_delay="0" post_join_delay="50"

./ccs -f test --addnode rh5node-single.examplerh.com

./ccs -f test --addservice foo
./ccs -f test --addsubservice foo ip address="1.2.3.4" sleeptime="10"
./ccs -f test --addsubservice foo mysql config_file="/etc/my.cnf" listen_address="192.168.1.183" mysqld_options="--log-error=/var/log/mysqld.log" name="mysql-server" shutdown_wait="200" startup_wait="200"

./ccs -f test --setrm log_facility="local4" log_level="7"
./ccs -f test --setcman quorum_dev_poll="50000"
./ccs -f test --settotem consensus="400"
