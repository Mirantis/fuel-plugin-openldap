Plugin Openldap
============
Intended to implement Openldap backend for keystone identity. Use standalone HW node for openldap master server, MOS controller nodes are slaves. See diagram Appendix-A.

Requirements
------------
     Plugin openldap currently compatible only with Mirantis OpenStack 7.0

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


How to create a self-signed SSL certificate
--------
```
# openssl genrsa -des3 -out server.key 1024
Generating RSA private key, 1024 bit long modulus
.....++++++
.++++++
e is 65537 (0x10001)
Enter pass phrase for server.key:****
Verifying - Enter pass phrase for server.key:****
```

Step 2: Generate a CSR (Certificate Signing Request)
-------
```
# openssl req -new -key server.key -out server.csr
Enter pass phrase for server.key: ****
You are about to be asked to enter information that will be incorporated

into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,

If you enter '.', the field will be left blank.
Country Name (2 letter code) [XX]:RU
State or Province Name (full name) []:Moscow
Locality Name (eg, city) [Default City]:Moscow
Organization Name (eg, company) [Default Company Ltd]:Mirantis-IT
Organizational Unit Name (eg, section) []:Service
Common Name (eg, your name or your server's hostname) []:domain.tld
Email Address []:akirilochkin@mirantis.com
```

Step 3: Remove Passphrase from Key
-------
```
# openssl rsa -in server.key.domain.tld -out server.key
Enter pass phrase for server.key.domain.tld:
writing RSA key
```

Step 4: Generating a Self-Signed Certificate
-------
```
# openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

Signature ok
subject=/C=RU/ST=Moscow/L=Moscow/O=Mirantis-IT/OU=Service/CN=domain.tld/emailAddress=akirilochkin@mirantis.com
Getting Private key
```
