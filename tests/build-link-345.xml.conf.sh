./ccs -f test --createcluster LINK_345
./ccs -f test --addnode link-03
./ccs -f test --addnode link-04
./ccs -f test --addnode link-05
./ccs -f test --addfencedev apc1 agent="fence_apc" ipaddr="link-apc" login="apc" passwd="apc"
./ccs -f test --addmethod APCEE link-03
./ccs -f test --addmethod APCEE link-04
./ccs -f test --addmethod APCEE link-05
./ccs -f test --addfenceinst apc1 link-03 APCEE switch="1" port="3"
./ccs -f test --addfenceinst apc1 link-04 APCEE switch="1" port="4"
./ccs -f test --addfenceinst apc1 link-05 APCEE switch="1" port="5"
