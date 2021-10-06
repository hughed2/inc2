#!/bin/bash

# Make sure we're running from the base directory
dirname=${PWD##*/}
if [ $dirname = 'tools' ]
then
  cd ..
fi

# Make sure our repo exists
if [ ! -d "$SPACK_ROOT/var/spack/repos/hpmusic" ]; then
  spack repo create $SPACK_ROOT/var/spack/repos/hpmusic hpmusic
  spack repo add $SPACK_ROOT/var/spack/repos/hpmusic
fi

# Now make sure our package exists
if [ ! -d "$SPACK_ROOT/var/spack/repos/hpmusic/packages/inc" ]; then
  spack create --skip-editor --repo $SPACK_ROOT/var/spack/repos/hpmusic --name inc
fi

# Move our tarball over
rm -f inc.tar.gz
tar -czf inc.tar.gz *
mv inc.tar.gz $SPACK_ROOT/var/spack/repos/hpmusic/packages/inc/

# Make sure package.py is updated
cp tools/package.py.TEMPLATE $SPACK_ROOT/var/spack/repos/hpmusic/packages/inc/package.py
tarhash=`md5sum $SPACK_ROOT/var/spack/repos/hpmusic/packages/inc/inc.tar.gz | awk '{print $1}'`
sed -i'.TEMPLATE' -e "s/<VERSION>/$tarhash/g" $SPACK_ROOT/var/spack/repos/hpmusic/packages/inc/package.py
