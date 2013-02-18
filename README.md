puppet-nginx
============

Note this installs nginx-extras which has additional modules enabled

Variables
---------

 * admin_hosts 
 * chunking 
 * fqdn 
 * name 
 * port 
 * server 
 * ssl 
 * upstreams 

Client

 * client_timeout 

Nagios

 * nagios_hosts 

SSL

 * ssl_certcombined_path 
 * ssl_key_path 

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



