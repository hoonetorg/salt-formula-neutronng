# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - neutron.install
  - neutron.config
  - neutron.service

extend:
  neutron_config__conffile:
    file:
      - require:
        - pkg: neutron_install__pkg
  neutron_service__service:
    service:
      - watch:
        - file: neutron_config__conffile
      - require:
        - pkg: neutron_install__pkg

