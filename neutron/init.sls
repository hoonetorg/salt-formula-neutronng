# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - neutron.config
  - neutron.service

extend:
  neutron_service__service:
    service:
      - watch:
        - cmd: neutron_config__syncdb
