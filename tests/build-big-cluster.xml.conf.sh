./ccs -f test --createcluster big-cluster
./ccs -f test --addnode tank-01
./ccs -f test --addnode tank-02
./ccs -f test --addnode tank-03
./ccs -f test --addnode tank-04
./ccs -f test --addnode tank-05
./ccs -f test --addnode tank-06
./ccs -f test --addnode morph-01
./ccs -f test --addnode morph-02
./ccs -f test --addnode morph-03
./ccs -f test --addnode morph-04
./ccs -f test --addnode morph-05
./ccs -f test --addfencedev apc agent="fence_apc" ipaddr="morph-apc" login="apc" passwd="apc"
./ccs -f test --addfencedev apc1 agent="fence_apc" ipaddr="tank-apc" login="apc" passwd="apc"
./ccs -f test --addmethod APCEE tank-01
./ccs -f test --addmethod APCEE tank-02
./ccs -f test --addmethod APCEE tank-03
./ccs -f test --addmethod APCEE tank-04
./ccs -f test --addmethod APCEE tank-05
./ccs -f test --addmethod APCEE tank-06
./ccs -f test --addmethod single morph-01
./ccs -f test --addmethod single morph-02
./ccs -f test --addmethod single morph-03
./ccs -f test --addmethod single morph-04
./ccs -f test --addmethod single morph-05
./ccs -f test --addfenceinst apc1 tank-01 APCEE switch="1" port="1"
./ccs -f test --addfenceinst apc1 tank-02 APCEE switch="1" port="2"
./ccs -f test --addfenceinst apc1 tank-03 APCEE switch="1" port="3"
./ccs -f test --addfenceinst apc1 tank-04 APCEE switch="1" port="4"
./ccs -f test --addfenceinst apc1 tank-05 APCEE switch="1" port="5"
./ccs -f test --addfenceinst apc1 tank-06 APCEE switch="1" port="6"
./ccs -f test --addfenceinst apc morph-01 single port="1:1"
./ccs -f test --addfenceinst apc morph-02 single port="1:2"
./ccs -f test --addfenceinst apc morph-03 single port="1:2"
./ccs -f test --addfenceinst apc morph-04 single port="1:4"
./ccs -f test --addfenceinst apc morph-05 single port="1:5"

