# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "neutron/map.jinja" import controller with context %}

neutron_service__service:
  service.{{ controller.service.state }}:
    - names: {{ controller.services }}
{% if controller.service.state in [ 'running', 'dead' ] %}
    - enable: {{ controller.service.enable }}
{% endif %}

