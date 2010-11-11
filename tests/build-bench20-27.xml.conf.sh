./ccs -f test --createcluster bench
./ccs -f test --setfencedaemon post_join_delay="20" clean_start="0"
./ccs -f test --addnode bench-20 nodeid="20"
./ccs -f test --addnode bench-21
./ccs -f test --addnode bench-22
./ccs -f test --addnode bench-23
./ccs -f test --addnode bench-24
./ccs -f test --addnode bench-25
./ccs -f test --addnode bench-26
./ccs -f test --addnode bench-27
