function check_all_ports {
    local host=$1

    for port in {1..65535}; do
        if nc -zv -w1 "$host" "$port" <<< '' 2>&1 | grep -q 'succeeded'; then
            echo "[*] Port $port is open"
        elif nc -zv -w1 "$host" "$port" <<< '' 2>&1 | grep -q 'refused'; then
            echo "[*] Port $port is closed (connection refused)"
        else
            echo ""
        fi
    done
}

check_all_ports "localhost"
