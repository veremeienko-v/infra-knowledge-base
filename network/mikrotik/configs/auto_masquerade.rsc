:if ($bound=1) do={
:if [:tobool ([/ip firewall/nat/ find comment="masquerade via ISP-1"])] do={
    /ip firewall nat set [find comment="masquerade via ISP-1"] action=masquerade chain=srcnat \
        out-interface=$"interface";
} else={ /ip firewall nat add action=masquerade chain=srcnat \
            out-interface=$"interface" comment="masquerade via ISP-1" }
} else={
    /ip firewall nat remove [find comment="masquerade via ISP-1"]
}

