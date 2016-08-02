# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "neutron/map.jinja" import user with context %}
{% from "neutron/map.jinja" import controller with context %}
{% from "neutron/map.jinja" import network with context %}
{% from "neutron/map.jinja" import compute with context %}
#{{user|json}}
#{{controller|json}}
#{{network|json}}
#{{compute|json}}

neutron_install__pkg:
  pkg.installed:
    - pkgs: {{ controller.pkgs }}
