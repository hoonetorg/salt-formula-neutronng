# -*- coding: utf-8 -*-
# vim: ft=sls

{%- from "neutron/map.jinja" import server with context %}

{%- set services = server.services %}
{%- if server.selfservice %}
{%- set services = services + server.services_selfservice %}
{%- endif %}

{% if server.get('backend', {}).get('engine', False) %}
#server.services_{{'services_' + server.backend.engine}}|length: {{server['services_' + server.backend.engine]|length}}

{%- if server['services_' + server.backend.engine]|length > 0 %}

neutron_service__service_{{server.backend.engine}}:
  service.{{ server['backend'][server.backend.engine]['service']['state'] }}:
    - names: {{ server['services_' + server.backend.engine] }}
{%- if server['backend'][server.backend.engine]['service']['state'] in [ 'running', 'dead' ] %}
    - enable: {{ server['backend'][server.backend.engine]['service']['enable'] }}
{%- endif %}
{%- if services|length > 0 %}
    - require_in:
      - service: neutron_service__service

{%- endif %}
{%- endif %}
{%- endif %}

{%- if services|length > 0 %}
neutron_service__service:
  service.{{ server.service.state }}:
    - names: {{ services }}
{%- if server.service.state in [ 'running', 'dead' ] %}
    - enable: {{ server.service.enable }}
{%- endif %}
{%- endif %}
