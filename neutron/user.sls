{%- from "neutron/map.jinja" import server with context -%}
neutron_user__user:
  user.present:
    - name: {{server.user.name}}
    - home: {{server.user.home}}
    - uid: {{server.user.uid}}
    - gid: {{server.group.gid}}
    - groups: {{server.user.groups|json}}
    - shell: {{server.user.shell}}
    - fullname: {{server.user.fullname}}
    - system: True

neutron_user__group:
  group.present:
    - name: {{server.group.name}}
    - gid: {{server.group.gid}}
    - system: True
    - require_in:
      - user: neutron_user__user
