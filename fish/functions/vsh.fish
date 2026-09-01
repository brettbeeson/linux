function vsh --description 'SSH to a PhiSaver VPN host as pi'
    if test (count $argv) -lt 1
        echo 'usage: vsh HOSTNAME [ssh options...]' >&2
        return 2
    end

    set -l host $argv[1]
    set -e argv[1]

    set -l ip (vip "$host"); or return
    test -n "$ip"; or begin
        echo "No VPN IP returned for $host" >&2
        return 1
    end

    ssh $argv "pi@$ip"
end
