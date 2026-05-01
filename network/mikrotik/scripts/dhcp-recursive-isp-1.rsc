:if ($bound=1) do={
    /ip route remove [ find where dst-address ~"8.8.8.8" ];
    /ip route add check-gateway=ping comment="Recursive route via ISP-1" distance=1 \
        dst-address=8.8.8.8/32 gateway=$"gateway-address" scope=10
:if [:tobool ([/ip firewall/nat/ find comment="masquerade via ISP-1"])] do={
    /ip firewall nat set [find comment="masquerade via ISP-1"] action=masquerade chain=srcnat \
        out-interface=$"interface";
} else={ /ip firewall nat add action=masquerade chain=srcnat \
            out-interface=$"interface" comment="masquerade via ISP-1" }
} else={
    /ip route remove [ find where dst-address ~"8.8.8.8" ]
    /ip firewall nat remove [find comment="masquerade via ISP-1"]
}