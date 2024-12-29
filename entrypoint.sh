#!/bin/bash
set -e

PATH=/usr/local/bin:$PATH

case $RTPENGINE_CLOUD in 
  gcp)
    RTPENGINE_LOCAL_IP=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)
    RTPENGINE_PUBLIC_IP=$(curl -s -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
    ;;
  aws)
    RTPENGINE_LOCAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
    RTPENGINE_PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
    ;;
  digitalocean)
    RTPENGINE_LOCAL_IP=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)
    RTPENGINE_PUBLIC_IP=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
    ;;
  azure)
    RTPENGINE_LOCAL_IP=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/privateIpAddress?api-version=2017-08-01&format=text")
    RTPENGINE_PUBLIC_IP=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/publicIpAddress?api-version=2017-08-01&format=text")
    ;;
  *)
    RTPENGINE_LOCAL_IP=`netdiscover -field privatev4`
    ;;
esac

[ -z "$RTPENGINE_BIND_NG_IP" ] && { export RTPENGINE_BIND_NG_IP='0.0.0.0'; }
[ -z "$RTPENGINE_BIND_NG_PORT" ] && { export RTPENGINE_BIND_NG_PORT=22222; }
[ -z "$RTPENGINE_BIND_HTTP_IP" ] && { export RTPENGINE_BIND_HTTP_IP='0.0.0.0'; }
[ -z "$RTPENGINE_BIND_HTTP_PORT" ] && { export RTPENGINE_BIND_HTTP_PORT=8080; }
[ -z "$RTPENGINE_PORT_MIN" ] && { export RTPENGINE_PORT_MIN=23000; }
[ -z "$RTPENGINE_PORT_MAX" ] && { export RTPENGINE_PORT_MAX=32768; }
[ -z "$RTPENGINE_LOG_LEVEL" ] && { export RTPENGINE_LOG_LEVEL=0; }

if [ -n "$RTPENGINE_PUBLIC_IP" ]; then
  MY_IP="$RTPENGINE_LOCAL_IP"!"$RTPENGINE_PUBLIC_IP"
else
  MY_IP=$RTPENGINE_LOCAL_IP
fi

sed -i -e "s/MY_IP/$MY_IP/g" /opt/rtpengine/rtpengine.conf
sed -i -e "s/BIND_NG_IP/$RTPENGINE_BIND_NG_IP/g" /opt/rtpengine/rtpengine.conf
sed -i -e "s/BIND_NG_PORT/$RTPENGINE_BIND_NG_PORT/g" /opt/rtpengine/rtpengine.conf
sed -i -e "s/BIND_HTTP_IP/$RTPENGINE_BIND_HTTP_IP/g" /opt/rtpengine/rtpengine.conf
sed -i -e "s/BIND_HTTP_PORT/$RTPENGINE_BIND_HTTP_PORT/g" /opt/rtpengine/rtpengine.conf
sed -i -e "s/PORT_MIN/$RTPENGINE_PORT_MIN/g" /opt/rtpengine/rtpengine.conf
sed -i -e "s/PORT_MAX/$RTPENGINE_PORT_MAX/g" /opt/rtpengine/rtpengine.conf
sed -i -e "s/LOG_LEVEL/$RTPENGINE_LOG_LEVEL/g" /opt/rtpengine/rtpengine.conf

if [ -n "$RTPENGINE_HOMER_ADDR" ]; then
  [ -z "$RTPENGINE_HOMER_PROTOCOL" ] && { export RTPENGINE_HOMER_PROTOCOL='udp'; }
  [ -z "$RTPENGINE_HOMER_ID" ] && { export HOMER_ID=$((RANDOM % 9000 + 1000)); }

  echo "homer=$RTPENGINE_HOMER_ADDR" >> /opt/rtpengine/rtpengine.conf
  echo "homer-protocol=$RTPENGINE_HOMER_PROTOCOL" >> /opt/rtpengine/rtpengine.conf
  echo "homer-id=$RTPENGINE_HOMER_ID" >> /opt/rtpengine/rtpengine.conf
fi

if [ "$1" = 'rtpengine' ]; then
  shift
  exec rtpengine --config-file /opt/rtpengine/rtpengine.conf  "$@"
fi

exec "$@"
