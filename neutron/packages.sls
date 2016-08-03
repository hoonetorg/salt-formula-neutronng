{%- from "neutron/map.jinja" import controller with context %}
{%- from "neutron/map.jinja" import network with context %}
{%- from "neutron/map.jinja" import compute with context %}

include:
- neutron.user

{%- set pkgs = [] %}

{%- if controller.get('enabled', False) %}
  {%- set pkgs = pkgs + controller.pkgs %}
{%- endif %}
{%- if network.get('enabled', False) %}
  {%- set pkgs = pkgs + network.pkgs %}
{%- endif %}
{%- if compute.get('enabled', False) %}
  {%- set pkgs = pkgs + compute.pkgs %}
{%- endif %}

neutron_packages__packages:
  pkg.installed:
  - names: {{ pkgs }}
  - require:
    - user: neutron_user__user
