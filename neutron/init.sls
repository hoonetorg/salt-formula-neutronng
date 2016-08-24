# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "neutron/map.jinja" import server with context %}

{%- set services = server.services %}
{%- if server.selfservice %}
{%- set services = services + server.services_selfservice %}
{%- endif %}

include:
  - neutron.config
  - neutron.service

extend:
{% if server.get('backend', {}).get('engine', False) %}
{%- if server['services_' + server.backend.engine]|length > 0 %}
  neutron_service__service_{{server.backend.engine}}:
    service:
      - require:
        - sls: neutron.config
{%- endif %}
{%- endif %}

{% if services|length > 0 %}
  neutron_service__service:
    service:
      - require:
        - sls: neutron.config
{%- endif %}
