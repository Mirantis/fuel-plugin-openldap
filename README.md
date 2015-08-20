plugin_sscc_openldap
============
Intended to implement Openldap backend for keystone identity. Use standalone HW node for openldap master server, MOS controller nodes are slaves. See diagram Appendix-A.

Requirements
------------
     Plugin_sscc_openldap currently compatible only with Mirantis OpenStack 6.1

Limitations
-----------
It is required to update openldap master node deployment settings via cli in order to configure networking properly (additional script which doing so shipped with plugin)
Only Identity stored in LDAP


Additional info
-----------

You can use built package provided in this directory. Or you can built plugin yourself. Please make sure that you use modified version
of plugin builder wich allows post install script execution.

Where you can find modified plugin builder:

https://github.com/sheva-serg/fuel-plugins

Short instruction for plugin Builder

  - Install system packages fpb module reiles on:
  - If you use Ubuntu, install packages `createrepo rpm dpkg-dev`
  - If you use CentOS, install packages `createrepo dpkg-devel dpkg-dev rpm rpm-build`

Install fpb using pip. It's a good idea to install it into a virtualenv env:

pip install -e 'git+https://github.com/sheva-serg/fuel-plugins.git#egg=fuel_plugin_builder&subdirectory=fuel_plugin_builder'




