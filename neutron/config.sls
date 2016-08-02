# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "neutron/map.jinja" import controller with context %}

neutron_config__conffile:
  file.managed:
    - name: {{ controller.conffile }}
    - source: salt://neutron/files/configtempl.jinja
    - template: jinja
    - context:
      confdict: {{controller|json}}
    - mode: 644
    - user: root
    - group: root
