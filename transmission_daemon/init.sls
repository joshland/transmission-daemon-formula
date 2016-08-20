{%- from "transmission_daemon/defaults.yaml" import rawmap with context -%}
{%- set datamap = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('transmission:default')) -%}

transmission-daemon:
  pkg:
    - installed
    - pkgs: {{ datamap.pkgs }}

{%- for instance in salt['pillar.get']('transmission:instances')|default([]) %}
{{ instance.configdir }}:
  file.directory:
    - user: {{ instance.daemonuser }}
    - group: {{ instance.get('daemongroup', instance.daemonuser) }}
    - dir_mode: {{ instance.get('directory_mode', "0755") }}
    - file_mode: {{ instance.get('directory_mode', "0644") }}
    - makedirs: True
    - recurse:
      - user
      - group
      - mode

{{ instance.watch }}:
  file.directory:
    - user: {{ instance.daemonuser }}
    - group: {{ instance.get('daemongroup', instance.daemonuser) }}
    - dir_mode: {{ instance.get('directory_mode', "0755") }}
    - file_mode: {{ instance.get('directory_mode', "0644") }}
    - makedirs: True
    - recurse:
      - user
      - group
      - mode

{{ instance.complete }}:
  file.directory:
    - user: {{ instance.daemonuser }}
    - group: {{ instance.get('daemongroup', instance.daemonuser) }}
    - dir_mode: {{ instance.get('directory_mode', "0755") }}
    - file_mode: {{ instance.get('directory_mode', "0644") }}
    - makedirs: True
    - recurse:
      - user
      - group
      - mode

{% if instance.has_key('incomplete') %}
{{ instance.incomplete }}:
  file.directory:
    - user: {{ instance.daemonuser }}
    - group: {{ instance.get('daemongroup', instance.daemonuser) }}
    - dir_mode: {{ instance.get('directory_mode', "0755") }}
    - file_mode: {{ instance.get('directory_mode', "0644") }}
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
{% endif %}

{{ datamap.config.defaults_path }}/transmission-{{ instance.instance }}.service:
  file.managed:
    - user: root
    - group: root
    - mode: "0644"
    - contents: |
        [Unit]
        Description=transmission-{{ instance.instance }}
        After=syslog.target network.target
        
        [Service]
        PIDFile=/run/transmission-daemon-{{ instance.instance }}.pid
        User={{ instance.daemonuser }}
        StandardError=syslog
        {%- include 'transmission_daemon/instances.jinja' with context %}
        
        [Install]
        WantedBy=multi-user.target

  service:
    - {{ datamap.service.state|default('running') }}
    - name: transmission-{{ instance.instance }}
    - enable: {{ datamap.service.enable|default(True) }}
    - watch:
      - file: {{ datamap.config.defaults_path }}/transmission-{{ instance.instance }}.service
    - require:
      - pkg: transmission-daemon
{% endfor %}