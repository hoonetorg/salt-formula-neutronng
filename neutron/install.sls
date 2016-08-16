# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "neutron/map.jinja" import server with context %}

neutron_install__pkg:
  pkg.installed:
    - pkgs: {{ server.pkgs }}
