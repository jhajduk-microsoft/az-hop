#!/bin/bash

set -ex
   
DISTRIB_CODENAME=el8
REPO_PATH=/etc/yum.repos.d/amlfs.repo
   
rpm --import https://packages.microsoft.com/keys/microsoft.asc
   
echo -e "[amlfs]" > ${REPO_PATH}
echo -e "name=Azure Lustre Packages" >> ${REPO_PATH}
echo -e "baseurl=https://packages.microsoft.com/yumrepos/amlfs-${DISTRIB_CODENAME}" >> ${REPO_PATH}
echo -e "enabled=1" >> ${REPO_PATH}
echo -e "gpgcheck=1" >> ${REPO_PATH}
echo -e "gpgkey=https://packages.microsoft.com/keys/microsoft.asc" >> ${REPO_PATH}

dnf install -y amlfs-lustre-client-2.15.1_24_gbaa21ca-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
