./ccs -f test --createcluster a_cluster
./ccs -f test --setfencedaemon post_join_delay="20" clean_start="0"
./ccs -f test --addnode a1
./ccs -f test --addnode a2
./ccs -f test --addnode a3
./ccs -f test --addfencedev apc1 agent="fence_apc" ipaddr="link-apc" login="apc" passwd="apc"
./ccs -f test --addmethod APCEE a1
./ccs -f test --addmethod APCEE a2
./ccs -f test --addmethod APCEE a3
./ccs -f test --addfenceinst apc1 a1 APCEE switch="4" port="8"
./ccs -f test --addfenceinst apc1 a2 APCEE switch="4" port="7"
./ccs -f test --addfenceinst apc1 a3 APCEE switch="4" port="6"
