#!/bin/sh
# accepted parameters: $length, stdin
# check file
read -n $length data
if [ -z "$data"];
 then
  exit 1
fi
# prepare tmp directory
TMP="/tmp/_upgrade"
rm -rf "$TMP"
mkdir "$TMP"
echo "$data" | base64 --decode | openssl enc -d -aes-256-cbc -pass file:/root/password > "$TMP/_image.tgz"
cd "$TMP"
# unzip and copy all
skip=no
tar xzf _image.tgz 2> /dev/null
if [ $? -gt 0 ];
 then
  skip=yes
fi
rm _image.tgz
if [ "$skip" = "no" ];
 then
  # first script
  if [ -f preinstall.sh ];
   then
    chmod +x preinstall.sh
    ./preinstall.sh
    [ $? -gt 0 ] && exit 1
  fi

  # old files removal
  if [ -f "-" ];
   then
    while read -r line; 
     do 
      rm -rf $line ; 
     done < "-"
  fi

  # new files
  if [ -d "+" ];
   then
    cd "+"
    chown -R root:root *
    cp -R * /
    cd ..
  fi

  # WWW interface
  if [ -f export.tgz ];
   then
    tar xzf export.tgz
    chown -R root:root export/*
    rm -rf /www/*
    mv export/* /www/
    ln -s /usr/share/cgi-bin /www/cgi-bin
    rmdir export
    rm export.tgz
  fi
  # VERSION setup
  [ -f version ] && mv version /www/

  # postinstall
  if [ -f postinstall.sh ];
   then
    chmod +x postinstall.sh
    ./postinstall.sh
    [ $? -gt 0 ] && exit 1
  fi

fi

cd /
rm -rf "$TMP"
[ "$skip" = "yes" ] && exit 1
exit 0
