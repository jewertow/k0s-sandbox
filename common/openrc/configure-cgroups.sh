#!/bin/sh

rc-update add cgroups boot

# remove -docker keyword so we actually mount cgroups in container
sed -i -e '/keyword/s/-docker//' /etc/init.d/cgroups
