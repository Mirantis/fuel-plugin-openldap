#!/usr/bin/python

import sys
import yaml
file = str(sys.argv[1])


def determine(item):
    if ((item.get('action')=="add-br" and item.get('name')=="br-prv") or \
       (item.get('action')=="add-br" and item.get('name')=="br-aux") or \
       (item.get('action')=="add-br" and item.get('name')=="br-floating") or \
       (item.get('action')=="add-port" and item.get('bridge')=="br-aux") or \
       (item.get('action')=="add-patch")):
        return True
    else:
        return False




with open (file, 'r') as ymlfile:
    cfg = yaml.load(ymlfile)

cfg['network_scheme']['endpoints'].pop('br-floating', None)
cfg['network_scheme']['endpoints'].pop('br-prv', None)
cfg['network_scheme']['roles'].pop('neutron/floating', None)
cfg['network_scheme']['roles'].pop('neutron/private', None)

cfg['network_scheme']['transformations'][:] = [item for item in cfg['network_scheme']['transformations'] if not determine(item)]

with open (file, 'w') as ymlfile:
    yaml.dump(cfg, ymlfile, default_flow_style=False)

