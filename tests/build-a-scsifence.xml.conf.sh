./ccs -f test --createcluster a_cluster
./ccs -f test --setfencedaemon post_join_delay="20" clean_start="0"
./ccs -f test --addnode a1
./ccs -f test --addnode a2
./ccs -f test --addnode a3
./ccs -f test --addfencedev my_lovely_array agent="fence_scsi"
./ccs -f test --addmethod scsi a1
./ccs -f test --addmethod scsi a2
./ccs -f test --addmethod scsi a3
./ccs -f test --addfenceinst my_lovely_array a1 scsi node="a1"
./ccs -f test --addfenceinst my_lovely_array a2 scsi node="a2"
./ccs -f test --addfenceinst my_lovely_array a3 scsi node="a3"
