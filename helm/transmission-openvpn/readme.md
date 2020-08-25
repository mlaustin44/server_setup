$ kubectl create secret generic openvpn \
    --from-literal username=<VPN_USERNAME> \
    --from-literal password=<VPN_PASSWORD> \
    --namespace media


kubectl create configmap openvpn-common-config --from-file openvpn.conf