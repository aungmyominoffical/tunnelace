

import 'package:hexcolor/hexcolor.dart';

class AppConstants {

  static String appName = "TunnelAce";
  static HexColor mainColor = HexColor("#324ea8");


  static String config = """client
proto udp
remote uk1.vpnocean.net 1194
dev tun
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
verify-x509-name server_oU9is2NpDEBoES4G name
auth SHA256
auth-nocache
cipher AES-128-GCM
tls-client
tls-version-min 1.2
tls-cipher TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256
ignore-unknown-option block-outside-dns
setenv opt block-outside-dns # Prevent Windows 10 DNS leak
verb 3
<ca>
-----BEGIN CERTIFICATE-----
MIIB1zCCAX2gAwIBAgIUCvYRNwSr/6ECSZW3rtNPCgA6FzcwCgYIKoZIzj0EAwIw
HjEcMBoGA1UEAwwTY25fVVRCTnZHNWtPUVRMZHhUZDAeFw0yMzA1MTcxNTQ1MjVa
Fw0zMzA1MTQxNTQ1MjVaMB4xHDAaBgNVBAMME2NuX1VUQk52RzVrT1FUTGR4VGQw
WTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARUvSO3/GWttXX7iZSSXsq/nAXmPT9l
Gsd7HH4Tu9XFWygWhd8/Y14a9Fqij9VzLaluordOf30PJzU5PHU20SI3o4GYMIGV
MB0GA1UdDgQWBBSyfqa3aEfS+C4H6OC8cGTsoPpXETBZBgNVHSMEUjBQgBSyfqa3
aEfS+C4H6OC8cGTsoPpXEaEipCAwHjEcMBoGA1UEAwwTY25fVVRCTnZHNWtPUVRM
ZHhUZIIUCvYRNwSr/6ECSZW3rtNPCgA6FzcwDAYDVR0TBAUwAwEB/zALBgNVHQ8E
BAMCAQYwCgYIKoZIzj0EAwIDSAAwRQIhANkY0XuZ3e9Lcrlo772d5rMy2cO5g+n6
EIUB62cuVWLsAiAxN7n4NzhJh7ERUZPHJsWqGwg/kug0wvAIC8hJ/D4qjw==
-----END CERTIFICATE-----
</ca>
<cert>
-----BEGIN CERTIFICATE-----
MIIB3TCCAYOgAwIBAgIRAO2CO9g4WVDJN+NKcS3gObAwCgYIKoZIzj0EAwIwHjEc
MBoGA1UEAwwTY25fVVRCTnZHNWtPUVRMZHhUZDAeFw0yMzA4MTgxNzAxMDJaFw0y
NTExMjAxNzAxMDJaMBUxEzARBgNVBAMMCjIwMjMtMDgtMjYwWTATBgcqhkjOPQIB
BggqhkjOPQMBBwNCAARUPCyXeGsdziXSH3e+Z46pqARMzzWAberYwfUkhopHHnXe
9wFjZgCJFEYovUI0dHSyrzqK4bY4JYMjE+UV9PJwo4GqMIGnMAkGA1UdEwQCMAAw
HQYDVR0OBBYEFFqdVnnDFZ++E9jhmkiacY4cpTkOMFkGA1UdIwRSMFCAFLJ+prdo
R9L4Lgfo4LxwZOyg+lcRoSKkIDAeMRwwGgYDVQQDDBNjbl9VVEJOdkc1a09RVExk
eFRkghQK9hE3BKv/oQJJlbeu008KADoXNzATBgNVHSUEDDAKBggrBgEFBQcDAjAL
BgNVHQ8EBAMCB4AwCgYIKoZIzj0EAwIDSAAwRQIgWkbt53W+NI3DLMD0eMZLUn0o
wiRrjkeL/SaN2a5tdfQCIQDnauwmsDA5Vd19qg3n6vdHuIPu7Fyj6YMHiXnCot5A
Bw==
-----END CERTIFICATE-----
</cert>
<key>
-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQglduXGMZqptO5Psf6
Vs7mS3wN53kSxrA6D1sJnsjcB5GhRANCAARUPCyXeGsdziXSH3e+Z46pqARMzzWA
berYwfUkhopHHnXe9wFjZgCJFEYovUI0dHSyrzqK4bY4JYMjE+UV9PJw
-----END PRIVATE KEY-----
</key>
<tls-crypt>
#
# 2048 bit OpenVPN static key
#
-----BEGIN OpenVPN Static key V1-----
02968726dc6592ec03a532392cfe34f8
52918e119d32a55c3d111e7c10275d4f
da059f367062dca106a3d63e15ca270c
f7cb8bf45ed6f1dfc982049881e75e41
132d895c525367606623035379864e6e
01522158829361cc723ae2a1c7d3dccc
0a0e15b6b467f469009c7ee151c4e816
db233e5287a49cb4149dab3d15a03e7f
038025e5a88091c1b62b01baae943299
2c11298d7fdd21cc373c8ec0b27e1347
5e3e7bfe0909ba8848546c8cab8b11a9
5c0a666d8611f4686bf00d02552d8b65
f4e05ffb635dc1c2278df9c05252efc6
487f8c2ff1f17138864d63377959ab29
f1518e6eb0c51e5f527538bed3f5eb34
8012adc0e60de1de8f91114b20ff9965
-----END OpenVPN Static key V1-----
</tls-crypt>

""";

}