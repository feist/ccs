./ccs -f test --createcluster name
./ccs -f test --addservice SAPTest
./ccs -f test --addsubservice SAPTest SAPInstance InstanceName="foo"
./ccs -f test --addsubservice SAPTest SAPDatabase SID="bar" DBTYPE="oracle"
./ccs -f test --addfencedev apc power_wait="3" agent="fence_apc"
