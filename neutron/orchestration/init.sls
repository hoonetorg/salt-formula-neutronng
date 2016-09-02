#!jinja|yaml
{%- set controller_node_ids = salt['pillar.get']('neutron:server:pcs:controller_node_ids') -%}
{%- set controller_admin_node_id = salt['pillar.get']('neutron:server:pcs:controller_admin_node_id') -%}
{%- set network_node_ids = salt['pillar.get']('neutron:server:pcs:network_node_ids') -%}
{%- set network_admin_node_id = salt['pillar.get']('neutron:server:pcs:network_admin_node_id') -%}
{%- set compute_node_ids = salt['pillar.get']('neutron:server:pcs:compute_node_ids') -%}
{%- set compute_admin_node_id = salt['pillar.get']('neutron:server:pcs:compute_admin_node_id') -%}
{%- set node_ids = [] %}
{%- set dup_node_ids = controller_node_ids + network_node_ids + compute_node_ids %}
{%- for node_id in dup_node_ids %}
# probably appending {{node_id}}
{%- if node_id not in node_ids %}
# appending {{node_id}}
{%- do node_ids.append(node_id) %}
# node_ids: {{node_ids}}
{%- endif %}
{%- endfor %}

# controller_node_ids: {{controller_node_ids|json}}
# controller_admin_node_id: {{controller_admin_node_id}}
# network_node_ids: {{network_node_ids|json}}
# network_admin_node_id: {{network_admin_node_id}}
# compute_node_ids: {{compute_node_ids|json}}
# compute_admin_node_id: {{compute_admin_node_id}}
# dup_node_ids: {{dup_node_ids}}
# node_ids: {{node_ids}}

{%- for node_id in node_ids %}
neutron_orchestration__install_{{node_id}}:
  salt.state:
    - tgt: {{node_id}}
    - expect_minions: True
    - sls: neutron.config
    - require_in:
      - salt: neutron_orchestration__pcs_controller
{%- endfor %}

{%- for controller_node_id in controller_node_ids %}
neutron_orchestration__service_controller_{{controller_node_id}}:
  salt.state:
    - tgt: {{controller_node_id}}
    - expect_minions: True
    - sls: neutron.service
    - require_in:
      - salt: neutron_orchestration__pcs_controller
{%- endfor %}

neutron_orchestration__pcs_controller:
  salt.state:
    - tgt: {{controller_admin_node_id}}
    - expect_minions: True
    - sls: neutron.pcs
    - pillar:
        neutron_type: controller

{%- for network_node_id in network_node_ids %}
neutron_orchestration__service_network_{{network_node_id}}:
  salt.state:
    - tgt: {{network_node_id}}
    - expect_minions: True
    - sls: neutron.service
    - require:
      - salt: neutron_orchestration__pcs_controller
    - require_in:
      - salt: neutron_orchestration__pcs_network
{%- endfor %}

neutron_orchestration__pcs_network:
  salt.state:
    - tgt: {{network_admin_node_id}}
    - expect_minions: True
    - sls: neutron.pcs
    - pillar:
        neutron_type: network

{%- for compute_node_id in compute_node_ids %}
neutron_orchestration__service_compute_{{compute_node_id}}:
  salt.state:
    - tgt: {{compute_node_id}}
    - expect_minions: True
    - sls: neutron.service
    - require:
      - salt: neutron_orchestration__pcs_network
    - require_in:
      - salt: neutron_orchestration__pcs_compute
{%- endfor %}

neutron_orchestration__pcs_compute:
  salt.state:
    - tgt: {{compute_admin_node_id}}
    - expect_minions: True
    - sls: neutron.pcs
    - pillar:
        neutron_type: compute
