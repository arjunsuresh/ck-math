#! /bin/bash

#
# Installation script for AIMET.
#
# See CK LICENSE.txt for licensing details.
# See CK COPYRIGHT.txt for copyright details.
#
# Developer(s):
# - Anton Lokhmotov, anton@dividiti.com, 2016.
#

# PACKAGE_DIR
# INSTALL_DIR


export CC=${CK_CC}
export FC=${CK_FC}
export AR=${CK_AR}

# Building OpenBLAS produces lots of output which gets redirected to file.
cd ${INSTALL_DIR}/${PACKAGE_SUB_DIR}

make -j ${CK_HOST_CPU_NUMBER_OF_PROCESSORS} ${TARGET} ${EXTRA2} ${EXTRA3}
if [ "${?}" != "0" ] ; then
  echo "Error: Building of Aimet failed!"
  exit 1
fi

###############################################################################
echo ""
echo "Installing ..."

make PREFIX=${INSTALL_DIR}/install install
if [ "${?}" != "0" ] ; then
  echo "Error: Installing of Aimet failed!"
  exit 1
fi

###############################################################################
echo ""
echo "Installed Aimet into '${INSTALL_DIR}/install'."

export PACKAGE_SKIP_LINUX_MAKE=YES

return 0
