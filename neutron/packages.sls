{%- from "neutron/map.jinja" import server with context %}

include:
- neutron.user

neutron_packages__packages:
  pkg.installed:
  - names: {{ server.pkgs }}
  - require:
    - user: neutron_user__user

{%- if server.engine %}
neutron_packages__packages_{{server.engine}}:
  pkg.installed:
  - names: {{ server['pkgs_' + server.engine] }}
  - require:
    - user: neutron_user__user
{%- endif %}

{%- if server.selfservice %}
neutron_packages__packages_selfservice:
  pkg.installed:
  - names: {{ server.pkgs_selfservice }}
  - require:
    - user: neutron_user__user
{%- endif %}
