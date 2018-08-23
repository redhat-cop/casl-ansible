#!/usr/bin/env python

import argparse
import json
import libvirt
import pdb

class Inventory(object):

    def __init__(self):
        self.parse_cli_args()

        self.inventory = {"_meta": {"hostvars": {}}}
        self.conn = libvirt.open("qemu:///system")

        if self.args.list:
            self.handle_list()
        else:
            self.inventory = self.inventory

        print(json.dumps(self.inventory))


    def handle_list(self):
        groups = {}
        ip_addrs = []

        domains = self.conn.listAllDomains()

        for dom in domains:
           device = dom.interfaceAddresses(0).keys()[0]
           device_ip = dom.interfaceAddresses(0)[device]['addrs'][0]['addr']

           ip_addrs.append(device_ip)
           self.inventory["_meta"]["hostvars"].update({device_ip: {'vars': {}}})

        self.inventory.update({'libvirt': {'hosts': ip_addrs, 'vars':{}}})


    def parse_cli_args(self):
        parser = argparse.ArgumentParser(description='Produce an Ansible Inventory from a file')
        parser.add_argument('--list', action='store_true', help='List Hosts')
        self.args = parser.parse_args()


Inventory()
