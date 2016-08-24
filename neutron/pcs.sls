# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "neutron/map.jinja" import server with context %}

{% set pcs = server.get('pcs', {}) %}

{% if pcs.neutron_cib is defined and pcs.neutron_cib %}
neutron_pcs__cib_present_{{pcs.neutron_cib}}:
  pcs.cib_present:
    - cibname: {{pcs.neutron_cib}}
{% endif %}

{% if 'resources' in pcs %}
{% for resource, resource_data in pcs.resources.items()|sort %}
neutron_pcs__resource_present_{{resource}}:
  pcs.resource_present:
    - resource_id: {{resource}}
    - resource_type: "{{resource_data.resource_type}}"
    - resource_options: {{resource_data.resource_options|json}}
{% if pcs.neutron_cib is defined and pcs.neutron_cib %}
    - require:
      - pcs: neutron_pcs__cib_present_{{pcs.neutron_cib}}
    - require_in:
      - pcs: neutron_pcs__cib_pushed_{{pcs.neutron_cib}}
    - cibname: {{pcs.neutron_cib}}
{% endif %}
{% endfor %}
{% endif %}

{% if 'constraints' in pcs %}
{% for constraint, constraint_data in pcs.constraints.items()|sort %}
neutron_pcs__constraint_present_{{constraint}}:
  pcs.constraint_present:
    - constraint_id: {{constraint}}
    - constraint_type: "{{constraint_data.constraint_type}}"
    - constraint_options: {{constraint_data.constraint_options|json}}
{% if pcs.neutron_cib is defined and pcs.neutron_cib %}
    - require:
      - pcs: neutron_pcs__cib_present_{{pcs.neutron_cib}}
    - require_in:
      - pcs: neutron_pcs__cib_pushed_{{pcs.neutron_cib}}
    - cibname: {{pcs.neutron_cib}}
{% endif %}
{% endfor %}
{% endif %}

{% if pcs.neutron_cib is defined and pcs.neutron_cib %}
neutron_pcs__cib_pushed_{{pcs.neutron_cib}}:
  pcs.cib_pushed:
    - cibname: {{pcs.neutron_cib}}
{% endif %}

neutron_pcs__empty_sls_prevent_error:
  cmd.run:
    - name: true
    - unless: true
