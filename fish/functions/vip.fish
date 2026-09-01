function vip --description 'Look up a PhiSaver VPN host IP'
    if test (count $argv) -ne 1
        echo 'usage: vip HOSTNAME' >&2
        return 2
    end

    curl -fsS "https://live.phisaver.com/vpn/ip/$argv[1]"
end
