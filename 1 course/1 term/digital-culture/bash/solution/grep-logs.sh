zgrep 'HTTP/1.1 5' *.gz | awk '{print $5}' | sort | uniq | tr '\n' ' '
