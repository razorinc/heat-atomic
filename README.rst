===========================
An Atomic cluster with Heat
===========================

These Heat_ templates will deploy a cluster of Atomic_ hosts.

.. _Heat https://wiki.openstack.org/wiki/Heat

.. _Atomic http://www.projectatomic.io/


Prerequisities
==============

1. OpenStack version Juno or later with the Heat and Neutron services running

2. Atomic Host cloud image (we leverage cloud-init) loaded in Glance

3. An SSH keypair loaded to Nova

4. A (Neutron) network with a pool of floating IP addresses available


Deployment
==========

At the very least you have to need to specify your Atomic image, SSH keypair, external
network and the number of hosts to deploy:

::

    heat stack-create my-atomic-cluster -f atomic-cluster.yaml \
        -P server_image=Fedora-Cloud-Atomic-22 \
        -P ssh_key_name=default \
        -P external_network=external \
        -P node_count=3

You can run `heat output-show my-atomic-cluster host_ips` to get the list of IP
address assigned to the hosts:

::

   [
     "10.23.68.158",
     "10.23.68.159",
     "10.23.68.160",
   ]

Note that the name of the SSH user differs for various cloud images. It's
`fedora` for Fedora images and `cloud-user` for the latest CentOS and RHEL.


If you want to add your own (perhaps internal) DNS servers, pass into the
`dns_nameserver` parameter separated by comas:

::
   heat stack-create my-atomic-cluster ... -P dns_nameserver=10.16.5.22,10.37.5.18

By specifying both `rhn_username` and `rhn_password`, your RHEL hosts will be
automatically registered (with `subscription-manager
register --username=... --password=... --auto-attach`).


There is no autoscaling set up in the templates, but you can change the cluster
capacity manually by signalling the `scale_up` or `scale_down` resources:

::

   heat resource-signal my-atomic-cluster scale_up
   heat resource-signal my-atomic-cluster scale_down

These will add or remove a single host.

You can also do a *stack update* and change the `node_count` parameter:

::

    heat stack-update my-atomic-cluster -f atomic-cluster.yaml \
        -P server_image=Fedora-Cloud-Atomic-22 \
        -P ssh_key_name=default \
        -P external_network=external \
        -P node_count=4


Copyright
=========

Copyright 2015 Red Hat, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
