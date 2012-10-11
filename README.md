Nginx puppet
============

Note this installs nginx-extras which has additional modules enabled

Variables
---------
ssl_cert_path - where on the filesystem the ssl cert lives
ssl_key_path  - where on the filesystem the ssl key lives

Note: If you tag these resources with 'sslcert' nginx will be restarted if these change.


Define a proxy
--------------

Eg. For openstack api do:


    nginx::proxy { 'osapi':
        port         => 8774,
        ssl          => true,
        upstreams    => ['api-1:18774', 'api-2:18774', 'api-3:18774'],
        nagios_check => false,
    }


Optional proxy settings
-----------------------
 * client_timeout - default 60s
 * chunking - Use the chunking module



