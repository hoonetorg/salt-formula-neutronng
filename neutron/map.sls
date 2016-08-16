# -*- coding: utf-8 -*-
# vim: ft=sls

{%- from "neutron/map.jinja" import common with context %}
{%- from "neutron/map.jinja" import controller with context %}
{%- from "neutron/map.jinja" import network with context %}
{%- from "neutron/map.jinja" import compute with context %}
{%- from "neutron/map.jinja" import server with context %}

neutron_map_common.map:
  file.managed:
    - name: /tmp/common.map
    - contents: |
        {{common|yaml(False)|indent(8)}}

neutron_map_controller.map:
  file.managed:
    - name: /tmp/controller.map
    - contents: |
        {{controller|yaml(False)|indent(8)}}

neutron_map_network.map:
  file.managed:
    - name: /tmp/network.map
    - contents: |
        {{network|yaml(False)|indent(8)}}

neutron_map_compute.map:
  file.managed:
    - name: /tmp/compute.map
    - contents: |
        {{compute|yaml(False)|indent(8)}}

neutron_map_server.map:
  file.managed:
    - name: /tmp/server.map
    - contents: |
        {{server|yaml(False)|indent(8)}}
