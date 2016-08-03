{%- from "neutron/map.jinja" import user with context -%}
neutron_user__user:
  user.present:
    - name: {{user.user.name}}
    - home: {{user.user.home}}
    - uid: {{user.user.uid}}
    - gid: {{user.group.gid}}
    - groups: {{user.user.groups|json}}
    - shell: {{user.user.shell}}
    - fullname: {{user.user.fullname}}
    - system: True

neutron_user__group:
  group.present:
    - name: {{user.group.name}}
    - gid: {{user.group.gid}}
    - system: True
    - require_in:
      - user: neutron_user__user
