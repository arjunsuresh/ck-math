#! /bin/bash

#
# Installation script for clBLAS.
#
# See CK LICENSE for licensing details.
# See CK COPYRIGHT for copyright details.
#
# Developer(s):
# - Grigori Fursin, 2015;
# - Anton Lokhmotov, 2016.
#

# PACKAGE_DIR
# INSTALL_DIR

cd ${INSTALL_DIR}

############################################################
echo ""
echo "Downloading '${PACKAGE_FILE}' ..."

rm -f ${PACKAGE_FILE}
wget ${PACKAGE_URL}
if [ "${?}" != "0" ] ; then
  echo "Error: downloading failed!"
  exit 1
fi

############################################################
echo ""
echo "Unbzipping ..."

bzip2 -d ${PACKAGE_FILE}
if [ "${?}" != "0" ] ; then
  echo "Error: unbzipping failed!"
  exit 1
fi

############################################################
echo ""
echo "Untarring ..."

tar xvf ${PACKAGE_FILE1}
if [ "${?}" != "0" ] ; then
  echo "Error: untarring failed!"
  exit 1
fi

############################################################
echo ""
echo "Cleaning ..."

cd ${INSTALL_DIR}

rm -f ${PACKAGE_FILE1}

rm -rf install
mkdir install

############################################################
echo ""
echo "Executing boostrap ..."

cd ${INSTALL_DIR}/boost_1_62_0
./bootstrap.sh
if [ "${?}" != "0" ] ; then
  echo "Error: cmake failed!"
  exit 1
fi

############################################################
# Check extra stuff
EXTRA_FLAGS=""

if [ "${CK_CPU_ARM_NEON}" == "ON" ] ; then
  EXTRA_FLAGS="$EXTRA_FLAGS -mfpu=neon"
fi

if [ "${CK_CPU_ARM_VFPV3}" == "ON" ] ; then
  EXTRA_FLAGS="$EXTRA_FLAGS -mfpu=vfpv3"
fi

############################################################
echo ""
echo "Building (can be very long) ..."

export BOOST_BUILD_PATH=$INSTALL_DIR/install
echo "using gcc : arm : ${CK_CXX} ${CK_CXX_FLAGS_FOR_CMAKE} ${CK_CXX_FLAGS_ANDROID_TYPICAL} ${EXTRA_FLAGS} -DNO_BZIP2 ;" > $BOOST_BUILD_PATH/user-config.jam

./b2 install toolset=gcc-arm target-os=android -j ${CK_HOST_CPU_NUMBER_OF_PROCESSORS} link=static --without-mpi --prefix=${BOOST_BUILD_PATH}
# Ignore exit since some libs are not supported for Android ...
#if [ "${?}" != "0" ] ; then
#  echo "Error: cmake failed!"
#  exit 1
#fi

exit 0
