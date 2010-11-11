#!/usr/bin/python

from xml.dom import minidom
import sys
debug = False

def main(argv):
    if len(argv) != 2:
        print "Usage: xmldiff.py xmlfile1 xmlfile2"
        sys.exit(1)

    f = open(argv[0], 'r')
    xml1 = f.read()
    f.close()

    f = open(argv[1], 'r')
    xml2 = f.read()
    f.close()

    dom1 = minidom.parseString(xml1)
    dom2 = minidom.parseString(xml2)

    if checkTags(dom1, dom2): print "MATCH"
    else: print "NO MATCH"
    if checkTags(dom2, dom1): print "MATCH"
    else: print "NO MATCH"

# verifies that all the tags, attributes, etc. in a are in b
def checkTags(a,b):
    anlist = a.childNodes
    bnlist = b.childNodes

    if compareNodeList(anlist,bnlist):
        return True
    else:
        return False
    return

# Compares 2 node lists and return true if they are equivalent
def compareNodeList(anlist,bnlist):
    for node in anlist:
        nodesMatch = False
        if node.nodeType == node.TEXT_NODE:
            continue

        if isEmptyNode(node):
            continue

# If we're looking for fence_daemon and it only exists in 1 then we can
# ignore it for now (it's always present in generated cluster.confs)
        if node.nodeName == "fence_daemon" and not isNodePresent("fence_daemon", bnlist):
            continue

        for bnode in bnlist:
            if bnode.nodeType == node.TEXT_NODE:
                continue
            if compareNodes(node,bnode):
                nodesMatch = True
                break

        if nodesMatch == False:
            return False


    return True

def compareNodes(a,b):
    if debug: print "compareNodes %s-%s" % (a.nodeName,b.nodeName)
    if a.nodeType != b.nodeType:
        return False
    if a.nodeName != b.nodeName:
        return False
    if a.nodeValue != b.nodeValue:
        return False

    for i in range (a.attributes.length):
        if debug: print "%s-%s" % (a.attributes.item(i).name, a.attributes.item(i).value)

        # We ignore the config_version
        if a.attributes.item(i).name == "config_version":
            continue

        # We ignore the alias
        if a.attributes.item(i).name == "alias":
            continue

        # We ignore the nodeid
        if a.attributes.item(i).name == "nodeid":
            continue

        attrMatch = False
        for j in range(b.attributes.length):
            if (a.attributes.item(i).name == b.attributes.item(j).name) and (a.attributes.item(i).value == b.attributes.item(j).value):
                attrMatch = True
                break
        if attrMatch != True:
            if debug: print "Match failed on %s-%s" % (a.attributes.item(i).name, a.attributes.item(i).value)
            return False

    if len(a.childNodes) > 0:
        return compareNodeList(a.childNodes, b.childNodes)

    return True

def isEmptyNode(node):
    if (node.hasAttributes() == False):
        if (len(node.childNodes) == 0):
            return True
        for node in node.childNodes:
            if node.nodeType == node.TEXT_NODE:
                continue
            if not isEmptyNode(node):
                return False
        return True
    return False


def isNodePresent(nodeName, nodeList):
    for i in range(nodeList.length):
        if nodeList.item(i).nodeName == nodeName:
            return True
    return False


if __name__ == "__main__":
    main(sys.argv[1:])

