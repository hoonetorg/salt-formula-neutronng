# -*- coding: utf-8 -*-
# vim: ft=sls

{%- from "neutron/map.jinja" import controller with context %}
{%- from "neutron/map.jinja" import network with context %}
{%- from "neutron/map.jinja" import compute with context %}
{%- from "neutron/map.jinja" import server with context %}

include:
- neutron.packages

neutron_config__file_neutron.conf:
  file.managed:
    - name: /etc/neutron/neutron.conf
    - source: salt://neutron/files/{{ server.version }}/neutron.conf.{{ grains.os_family }}
    - template: jinja
    - require:
      - pkg: neutron_packages__packages

#currently not necessary - /usr/share/neutron/api-paste.ini is unchanged so far
#neutron_config__file_api-paste.ini:
#  file.managed:
#    - name: /etc/neutron/api-paste.ini
#    - source: salt://neutron/files/{{ server.version }}/api-paste.ini.{{ grains.os_family }}
#    - template: jinja
#    - require:
#      - pkg: neutron_packages__packages

{%- if network.get('enabled', False) %}
# it's probably ok to always install a dhcp agent, because networks can be created without using dhcp
# so if dhcp is not needed -> it won't be used
neutron_config__file_dhcp_agent.ini:
  file.managed:
    - name: /etc/neutron/dhcp_agent.ini
    - source: salt://neutron/files/{{ server.version }}/dhcp_agent.ini.{{ grains.os_family }}
    - template: jinja
    - require:
      - pkg: neutron_packages__packages

neutron_config__file_metadata_agent.ini:
  file.managed:
    - name: /etc/neutron/metadata_agent.ini
    - source: salt://neutron/files/{{ server.version }}/metadata_agent.ini.{{ grains.os_family }}
    - template: jinja
    - require:
      - pkg: neutron_packages__packages

{%- if server.selfservice %}
neutron_config__file_l3_agent.ini:
  file.managed:
    - name: /etc/neutron/l3_agent.ini
    - source: salt://neutron/files/{{ server.version }}/l3_agent.ini.{{ grains.os_family }}
    - template: jinja
    - require:
      - pkg: neutron_packages__packages
{%- endif %}
{%- endif %}

{%- if network.get('enabled', False) or compute.get('enabled', False) %}
{%- if server.get('backend', {}).get('engine', False) %}
{%- if server.backend.engine in ['linuxbridge'] %}
neutron_config__file_backend_{{server.backend.engine}}:
  file.managed:
    - name: /etc/neutron/plugins/ml2/linuxbridge_agent.ini
    - source: salt://neutron/files/{{ server.version }}/plugins/ml2/linuxbridge_agent.ini.{{ grains.os_family }}
    - template: jinja
    - require:
      - pkg: neutron_packages__packages
{%- endif %}
{%- endif %}
{%- endif %}


{%- if controller.get('enabled', False) %}
{%- if server.plugin in ['ml2'] %}
neutron_config__file_plugin_{{server.plugin}}:
  file.managed:
    - name: /etc/neutron/plugins/ml2/ml2_conf.ini
    - source: salt://neutron/files/{{ server.version }}/plugins/ml2/ml2_conf.ini.{{ grains.os_family }}
    - template: jinja
    - require:
      - pkg: neutron_packages__packages

{%- if grains['os_family'] in ['RedHat'] %}
neutron_config__file_default_plugin:
  file.symlink:
    - name: /etc/neutron/plugin.ini
    - target: /etc/neutron/plugins/ml2/ml2_conf.ini
    - require: 
      - file: neutron_config__file_plugin_{{server.plugin}}
{%- else %}
neutron_config__file_default_plugin:
  file.managed:
    - name: {{server.sysconfdir}}/neutron-server
    - source: salt://neutron/files/{{ server.version }}/neutron-server.{{ grains.os_family }}
    - template: jinja
    - require:
      - pkg: neutron_packages__packages
    - require_in:
      - file: neutron_config__file_plugin_{{server.plugin}}
{%- endif %}
{%- endif %}


neutron_config__syncdb:
  cmd.run:
    - names:
{%- if server.plugin in ['ml2'] %}
      - neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head
{%- elif server.plugin in ['opencontrail'] %}
      - neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/opencontrail/ContrailPlugin.ini upgrade head
{%- elif server.plugin in ['midonet'] %}
      - neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/midonet/midonet.ini upgrade head
{%- endif %}
    - user: {{server.user.name}}
    - group: {{server.group.name}}
    - require:
      - file: neutron_config__file_neutron.conf
      #- file: neutron_config__file_api-paste.ini
      #- file: neutron_config__file_backend_{{server.backend.engine}}
      - file: neutron_config__file_plugin_{{server.plugin}}
      - file: neutron_config__file_default_plugin
      #- file: neutron_config__file_dhcp_agent.ini
      #- file: neutron_config__file_metadata_agent.ini
{%- if server.selfservice %}
      #- file: neutron_config__file_l3_agent.ini
{%- endif %}

{%- endif %}
