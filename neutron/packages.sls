{%- from "neutron/map.jinja" import server with context %}

include:
- neutron.user

{%- if server.get('backend', {}).get('engine', False) %}
#server.pkgs_{{'pkgs_' + server.backend.engine}}|length: {{server['pkgs_' + server.backend.engine]|length}}
{%- if server['pkgs_' + server.backend.engine]|length > 0 %}
neutron_packages__packages_{{server.backend.engine}}:
  pkg.installed:
  - names: {{ server['pkgs_' + server.backend.engine] }}
  - require:
    - user: neutron_user__user
  - require_in:
    - pkg: neutron_packages__packages
{%- endif %}
{%- endif %}

{%- if server.selfservice %}
#server.pkgs_selfservice|length: {{server.pkgs_selfservice|length}}
{%- if server.pkgs_selfservice|length > 0 %}
neutron_packages__packages_selfservice:
  pkg.installed:
  - names: {{ server.pkgs_selfservice }}
  - require:
    - user: neutron_user__user
  - require_in:
    - pkg: neutron_packages__packages
{%- endif %}
{%- endif %}

neutron_packages__packages:
  pkg.installed:
  - names: {{ server.pkgs }}
  - require:
    - user: neutron_user__user

