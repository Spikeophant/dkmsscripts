#!/bin/bash

cd ../$kernelver/$arch/module/

for kernel_object in *ko; do
     echo "Signing kernel_object: $kernel_object"
    /usr/src/kernel/$kernelver/scripts/sign-file sha256 /root/dkms/kernel_signing_key.priv /root/dkms/kernel_signing_key.der "$kernel_object";
done

