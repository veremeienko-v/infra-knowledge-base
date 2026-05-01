:if ($bound=1) do={
    /ip route remove [ find where dst-address ~"9.9.9.9" ];
    /ip route add check-gateway=ping comment="Recursive route via ISP-3" distance=1 \
        dst-address=9.9.9.9/32 gateway=$"gateway-address" scope=10
:if [:tobool ([/ip firewall/nat/ find comment="masquerade via ISP-3"])] do={
    /ip firewall nat set [find comment="masquerade via ISP-3"] action=masquerade chain=srcnat \
        out-interface=$"interface";
} else={ /ip firewall nat add action=masquerade chain=srcnat \
            out-interface=$"interface" comment="masquerade via ISP-3" }
} else={
    /ip route remove [ find where dst-address ~"9.9.9.9" ]
    /ip firewall nat remove [find comment="masquerade via ISP-3"]
}

