./ccs -f test --createcluster duck
./ccs -f test --setfencedaemon clean_start="0" post_fail_delay="0" post_join_delay="3"

./ccs -f test --addnode huey.lab.bos.redhat.com
./ccs -f test --addnode dewey.lab.bos.redhat.com
./ccs -f test --addmethod 1 dewey.lab.bos.redhat.com
./ccs -f test --addmethod 2 dewey.lab.bos.redhat.com
./ccs -f test --addnode louey.lab.bos.redhat.com

./ccs -f test --addfencedev testname agent="fence_ipmilan" auth="md5" ipaddr="testip" lanplus="1" login="testlogin" passwd="testpass"
./ccs -f test --addfencedev testd5 agent="fence_drac5" ipaddr="ipd5" login="logind5" modulename="modd5" passwd="passd5" power_wait="100" secure="1"
./ccs -f test --addfencedev vmwaretest agent="fence_vmware" ipaddr="vmwarehost" login="vmwarelogin" passwd="vmwarepass" vmware_type="server1"
./ccs -f test --addfencedev apctest agent="fence_apc" ipaddr="1.2.3.4" login="apc" passwd="apc"
./ccs -f test --addfencedev wtitest agent="fence_wti" ipaddr="1.2.3.4" passwd="a" power_wait="3"
./ccs -f test --addfencedev apcapcacp agent="fence_apc" ipaddr="1.2.3.12" login="apcuser" passwd="apcpass" power_wait="12"
./ccs -f test --addfencedev dractest agent="fence_drac" ipaddr="1.2.3.9" login="login" modulename="mod" passwd="pass" power_wait="9"
./ccs -f test --addfencedev wtitestl agent="fence_wti" ipaddr="1.2.3.11" passwd="wtipass" power_wait="11"
./ccs -f test --addfencedev sanboxtest agent="fence_sanbox2" ipaddr="1.2.3.10" login="slogin" passwd="spass" power_wait="10"
./ccs -f test --addfencedev vmwarelsls agent="fence_vmware" ipaddr="1.2.3.3" login="vmwal" passwd="vmpass" power_wait="3" vmware_datacenter="datac" vmware_type="esx"
./ccs -f test --addfencedev lpartest agent="fence_lpar" ipaddr="1.2.3.5" login="lparuser" passwd="lparpass" power_wait="5" secure="1"
./ccs -f test --addfencedev ilotest agent="fence_ilo" hostname="1.2.3.6" login="ilologin" passwd="ilogpass" power_wait="6"
./ccs -f test --addfencedev rsatest agent="fence_rsa" ipaddr="1.2.3.7" login="rsalog" passwd="rsapass" power_wait="7"
./ccs -f test --addfencedev bctest agent="fence_bladecenter" ipaddr="1.3.3.8" login="blogin" passwd="bpass" power_wait="8"
./ccs -f test --addfencedev ciscomds agent="fence_cisco_mds" ipaddr="mdshost" login="mdslogin" passwd="mdspass" snmp_priv_passwd="snmpprivpass" snmp_version="2c"
./ccs -f test --addfencedev mds2 agent="fence_cisco_mds" ipaddr="mdshost" login="mdslogin" passwd="mdspass"

./ccs -f test --addfenceinst testname dewey.lab.bos.redhat.com 1
./ccs -f test --addfenceinst vmwaretest dewey.lab.bos.redhat.com 1 port="3"
./ccs -f test --addfenceinst wtitest dewey.lab.bos.redhat.com 1 port="4"
./ccs -f test --addfenceinst mds2 dewey.lab.bos.redhat.com 1 port="33"

./ccs -f test --addfenceinst testd5 dewey.lab.bos.redhat.com 2
./ccs -f test --addfenceinst apcapcacp dewey.lab.bos.redhat.com 2 option="off" port="12"
./ccs -f test --addfenceinst dractest dewey.lab.bos.redhat.com 2
./ccs -f test --addfenceinst wtitestl dewey.lab.bos.redhat.com 2 option="off" port="11"
./ccs -f test --addfenceinst sanboxtest dewey.lab.bos.redhat.com 2 port="10"
./ccs -f test --addfenceinst vmwarelsls dewey.lab.bos.redhat.com 2 port="3"
./ccs -f test --addfenceinst lpartest dewey.lab.bos.redhat.com 2 managed="hi" partition="3" secure="1"
./ccs -f test --addfenceinst ilotest dewey.lab.bos.redhat.com 2
./ccs -f test --addfenceinst rsatest dewey.lab.bos.redhat.com 2
./ccs -f test --addfenceinst bctest dewey.lab.bos.redhat.com 2 blade="3"
./ccs -f test --addfenceinst apcapcacp dewey.lab.bos.redhat.com 2 option="on" port="12"
./ccs -f test --addfenceinst wtitestl dewey.lab.bos.redhat.com 2 option="on" port="11"

./ccs -f test --addresource SAPDatabase AUTOMATIC_RECOVER="true" DBJ2EE_ONLY="true" DBTYPE="ORA" DB_JARS="/java/jdbc" DIR_BOOTSTRAP="/j2ee/inst/boot" DIR_EXECUTABLE="sapdbdir" DIR_SECSTORE="/j2ee/sec/store" JAVA_HOME="/java/path" NETSERVICENAME="oracletns" POST_START_USEREXIT="/post/start" POST_STOP_USEREXIT="/post/stop" PRE_START_USEREXIT="/pre/start" PRE_STOP_USEREXIT="/pre/stop" SID="sapdbname" STRICT_MONITORING="true"
./ccs -f test --addresource oracledb home="oraclehome" name="oraclesid" type="ias" user="oracleuser" vhost="vhost"

./ccs -f test --addservice sadadssad autostart="0" exclusive="0"
./ccs -f test --addsubservice sadadssad oracledb home="olh" name="oraclelocal" type="ias" user="olo" vhost="olvh"
./ccs -f test --addsubservice sadadssad oracledb ref="oraclesid"
./ccs -f test --addsubservice sadadssad oracledb[1]/script file="/bin/true" name="test"

./ccs -f test --setcman expected_votes="5"
./ccs -f test --addquorumd label="adads" min_score="7"
