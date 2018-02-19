#/bin/bash

#This will create /root/dkms if not exist
#Then create keys
#Then create a MOK request, input passwords if necessary, reboot
#And the new key will be aded to the MOK allowing the signing of kernel moduels
#for local use iwth this key, then you can use the DKMS conf files to automate this with DKMS

if (! `ls /root/dkms`); then
    mkdir /root/dkms
fi

if (! `ls /root/dkms/kernel_sign.config`); then
    cp ../templates/opensssl_key_generation_config.template /root/dkms/kernel_sign.config
fi

if (! `ls /root/dkms/kernel_ko_signing_key.der`); then

    openssl req -x509 -new -nodes -utf8 -sha256 -days 36500 -batch -config /root/dkms/kernel_sign.config -outform DER -out /root/dkms/kernel_ko_signing_key.der -keyout /root/dkms/kernel_ko_signing_key.priv
fi

mokutil --import /root/dkms/kernel_ko_signing_key.der

echo "please reboot for changes to take effect, then manually sign any .ko's that are already compiled with /usr/src/kernels/$(uname -r)/scripts/sign-file sha256 /root/dkms/kernel_signing_key.priv /root/dkms/kernel_signing_key.der /lib/modules/$(uname -r)/extra/razerfirefly.ko .  use the templates/dkms_conf.template to create /etc/dkms/{module}.conf files to enable automatic signing on recompile"
