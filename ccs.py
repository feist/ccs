#!/usr/bin/python

import getopt, sys
import socket, ssl
from xml.dom import minidom
import logging
import os
import os.path

RICCI_PORT = 11111

password = ""

def main(argv):
    hostname = "localhost"
    getconf = False
    status = fence = debug = start = stop = False
    listnodes = listservices = listdomains = False
    addnode = removenode = getversion = False
    incrementversion = setversion = False
    createcluster = False
    passwordset = False
    global password
#    logging.basicConfig(level=logging.DEBUG)
    try:
        opts, args = getopt.getopt(argv, "dh:p:", ["help","host=","getconf","status","fence=","start","stop","listnodes",
	  "listservices", "listdomains", "addnode=", "removenode=", "getversion","setversion=","incversion",
	  "createcluster=", "password="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt == ("--help"): usage() ; sys.exit()
        elif opt in ("--host","-h"):
            hostname = arg
            logging.debug("Hostname = %s" % hostname)
	elif opt in ("--password", "-p"): passwordset = True ; password = arg
        elif opt in ("--getconf"): getconf = True
        elif opt in ("--status"): status = True
        elif opt in ("--fence"): fence = True ;  node = arg
	elif opt in ("--start"): start = True
	elif opt in ("--stop"): stop = True
	elif opt in ("--listnodes"): listnodes = True
	elif opt in ("--listservices"): listservices = True
	elif opt in ("--listdomains"): listdomains = True
	elif opt in ("--addnode"): addnode = True ; node = arg 
	elif opt in ("--removenode"): removenode = True ; node = arg 
	elif opt in ("--getversion"): getversion = True
	elif opt in ("--setversion"): setversion = True ; version = arg 
	elif opt in ("--incversion"): incrementversion = True
        elif opt in ("--createcluster"):
	    createcluster = True
	    clustername = arg
	elif opt in ("d"): debug = True
	 
    if (getconf): get_cluster_conf(hostname)
    if (status): get_cluster_status(hostname)
    if (fence): fence_node(hostname, node)
    if (stop): stop_node(hostname) 
    if (start): start_node(hostname)
    if (listnodes): list_nodes(hostname)
    if (listservices): list_services(hostname)
    if (listdomains): list_domains(hostname)
    if (addnode): add_node(hostname, node)
    if (removenode): remove_node(hostname, node)
    if (getversion): print get_version(hostname)
    if (setversion): set_version(hostname, version)
    if (incrementversion): increment_version(hostname)
    if (createcluster): create_cluster(hostname, clustername)
        
def usage():
    print """
Usage: ccs [OPTION]
Remotely control cluster infrastructure.

      --help			Display this help and exit
  -h, --host			Ricci host to connect to (defaults to localhost)
  -p, --password		Root password for node running ricci
      --getconf			Print current cluster.conf file
      --status			Print current cluster status
      --fence <node>		Fence the node <node>
      --start			Start cluster services on host
      --stop			Stop cluster services on host
      --listnodes		List all nodes in the cluster
      --listservices		List all services in the cluster
      --addnode <node>		Add node <node> to the cluster
      --removenode <node>	Remove a node from the cluster
      --getversion		Get the current cluster.conf version
      --setversion		Set the cluster.conf version
      --incversion		Increment the cluster.conf version by 1
      				scp and put them in the current directory
      --createcluster <cluster>	Create a new cluster.conf
  """

def fence_node(hostname, node):
    xml = send_ricci_command(hostname, "cluster", "fence_node",("nodename","string",node)) 
    print xml
    
def stop_node(hostname):
    xml = send_ricci_command(hostname, "cluster", "stop_node")
    print xml
    
def start_node(hostname):
    xml = send_ricci_command(hostname, "cluster", "start_node")
    print xml
    
def get_cluster_conf(hostname):
    xml = get_cluster_conf_xml(hostname)
    xml = minidom.parseString(xml).getElementsByTagName('cluster')[0].toprettyxml(indent='  ',newl='')
    print xml

def get_cluster_status(hostname):
    xml = send_ricci_command(hostname,"cluster","status")
    xml = minidom.parseString(xml).getElementsByTagName('cluster')[0].toprettyxml(indent='  ',newl='')
    print xml

def list_nodes(hostname):
    xml = get_cluster_conf_xml(hostname)
    dom = minidom.parseString(xml)
    for node in dom.getElementsByTagName('clusternode'):
        print node.getAttribute("name")

def list_services(hostname):
    xml = get_cluster_conf_xml(hostname)
    dom = minidom.parseString(xml)
    for node in dom.getElementsByTagName('service'):
        print node.getAttribute("name")

def list_domains(hostname):
    xml = get_cluster_conf_xml(hostname)
    dom = minidom.parseString(xml)
    for node in dom.getElementsByTagName('failoverdomain'):
        print node.getAttribute("name")

# Add a node to the cluster.conf
#   Before adding a node we need to verify another node
#   with the same name doesn't already exist
def add_node(hostname, node_to_add):
    nodeid_list = set()

    dom = minidom.parseString(get_cluster_conf_xml(hostname))
    for node in dom.getElementsByTagName('clusternode'):
        if (node.getAttribute("name") == node_to_add):
            print "A node already exists with name: %s" % node_to_add
            sys.exit(1)
	nodeid_list.update(node.getAttribute("nodeid"))
    node = dom.createElement("clusternode")
    node.setAttribute("name",node_to_add)

    # Use the first nodeid above 0 that isn't already used
    nodeid = 0
    while (True):
        nodeid = nodeid + 1
	if (str(nodeid) not in nodeid_list): break

    node.setAttribute("nodeid",str(nodeid))
    node.setAttribute("votes","1")
    dom.getElementsByTagName("clusternodes")[0].appendChild(node)
    print "Add node"
    set_cluster_conf(hostname,dom.toxml())

def remove_node(hostname, node_to_remove):
    nodeFound = False

    dom = minidom.parseString(get_cluster_conf_xml(hostname))
    for node in dom.getElementsByTagName('clusternode'):
        if (node.getAttribute("name") == node_to_remove):
            node.parentNode.removeChild(node)
	    nodeFound = True
    if (nodeFound == False):
        print "Unable to find node %s" % node_to_remove
	sys.exit(1)

    set_cluster_conf(hostname,dom.toxml())

def get_version(hostname):
    dom = minidom.parseString(get_cluster_conf_xml(hostname))
    return dom.getElementsByTagName('cluster')[0].getAttribute("config_version")

def set_version(hostname, version):
    dom = minidom.parseString(get_cluster_conf_xml(hostname))
    dom.getElementsByTagName('cluster')[0].setAttribute("config_version",version)
    set_cluster_conf(hostname,dom.toxml())

def increment_version(hostname):
    new_version = int(get_version(hostname)) + 1
    set_version(hostname,str(new_version))
    print new_version

def get_cluster_conf_xml(hostname):
    xml = send_ricci_command(hostname, "cluster", "get_cluster.conf")
    dom = minidom.parseString(xml)
    if dom.getElementsByTagName('cluster').length > 0:
      return dom.getElementsByTagName('cluster')[0].toxml()
    else:
      return empty_cluster_conf()

# Create a minimal cluster.conf file similiar to the one
# created by system-config-cluster
def empty_cluster_conf(name="cluster"):
    impl = minidom.getDOMImplementation()
    newdoc = impl.createDocument(None, "cluster", None)

    top = newdoc.documentElement
    top.setAttribute('alias',name)
    top.setAttribute('config_version','1')
    top.setAttribute('name',name)
    fence_daemon = newdoc.createElement("fence_daemon")
    fence_daemon.setAttribute('post_fail_delay','0')
    fence_daemon.setAttribute('post_join_delay','3')
    clusternodes = newdoc.createElement("clusternodes")
    cman = newdoc.createElement("cman")
    fencedevices = newdoc.createElement("fencedevices")
    rm = newdoc.createElement("rm")
    failoverdomains = newdoc.createElement("failoverdomains")
    resources = newdoc.createElement("resources")
    
    top.appendChild(fence_daemon)
    top.appendChild(clusternodes)
    top.appendChild(cman)
    top.appendChild(fencedevices)
    rm.appendChild(failoverdomains)
    rm.appendChild(resources)
    top.appendChild(rm)

    return newdoc.toprettyxml()

def create_cluster(hostname, clustername):
    xml = empty_cluster_conf(clustername)
    set_cluster_conf(hostname,xml)

def set_cluster_conf(hostname,xml):
    xml = xml.replace('<?xml version="1.0" ?>','')
    print xml
    print send_ricci_command(hostname, "cluster", "set_cluster.conf", ("cluster.conf","xml","",xml))

def send_ricci_command(hostname, module, command, *vars):
    global password
    variables = ""

    for value in vars:
        variables = variables + '<var mutable="false" name="%s" type="%s" value="%s">' % (value[0],value[1],value[2])
	if (len(value) > 3):
	    variables = variables + value[3]
	variables = variables + "</var>"

    
    # Make sure that we can authenticate, if not bail out
    authenticate = False
    if authenticate == True:
        msg = '<ricci function="authenticate" password="%s" version="1.0"/>' % password
        res = send_to_ricci(hostname, msg)     
        dom = minidom.parseString(res[1])
        ricci_elem = dom.getElementsByTagName('ricci')
        if (ricci_elem[0].getAttribute("authenticated") != "true"): 
            print "Unable to authenticate with ricci node, please check root password."
            sys.exit(1)
	
    msg = '<ricci function="process_batch" async="false" version="1.0"><batch><module name="%s"><request API_version="1.0"><function_call name="%s">%s</function_call></request></module></batch></ricci>' % (module,command,variables)
    res = send_to_ricci(hostname, msg)
    dom = minidom.parseString(res[1].replace('\t',''))
    xml =  (dom.getElementsByTagName('function_response')[0].toxml())
    return xml 

def send_to_ricci(hostname, msg):
    cert = os.path.expanduser("~/.ricci/cacert.pem")
    key = os.path.expanduser("~/.ricci/privkey.pem")
    config = os.path.expanduser("~/.ricci/cacert.config")
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Make sure we have a client certificate and private key
    # If not we need to autogenerate them (including creating an
    # openssl configuration file
    if (os.path.isfile(cert) == False or os.path.isfile(key) == False):
	print "Autogenerating private key and certificate."
	if not os.path.exists(os.path.expanduser("~/.ricci")):
	    os.mkdir(os.path.expanduser("~/.ricci"),0700);
        f = open (config, 'w')
        f.write("""
      [ req ]
      distinguished_name     = req_distinguished_name
      attributes             = req_attributes
      prompt                 = no

      [ req_distinguished_name ]
      C                      = US
      ST                     = State or Province
      L                      = Locality
      O                      = Organization Name
      OU                     = Organizational Unit Name
      CN                     = Common Name
      emailAddress           = root@localhost

      [ req_attributes ]
""")
        f.close()
        os.system ("/usr/bin/openssl genrsa -out %s 2048" % key)
        os.system ("/usr/bin/openssl req -new -x509 -key %s -out %s -days 1825 -config ~/.ricci/cacert.config" % (key,cert))

    ss = ssl.wrap_socket(s, key, cert)
    try:
	ss.connect((hostname, RICCI_PORT))
    except socket.error:
	print "Unable to connect to %s, make sure the ricci server is started." % hostname
	sys.exit(1)

    print "XXXSending to ricci server:"
    print msg
    print "YYYSending End"
    logging.debug("Connected...")
    res1 = ss.read(1024)
    logging.debug("Writing...")
    logging.debug(msg)
    ss.write(msg)
    logging.debug("Writen...")
    res2 = ''
    while True:
        logging.debug("Waiting to read...")
        buff = ss.read(10485760)
        logging.debug(buff)
        logging.debug("Read...")
        if buff == '':
            break
        res2 += buff
        try:
            minidom.parseString(res2)
            break
        except:
            pass
    print "XXXReceived from ricci server"
    print res2
    print "YYYReceive End"
    return res1, res2

if __name__ == "__main__":
    main(sys.argv[1:])
