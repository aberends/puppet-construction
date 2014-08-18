# We want some easy aliases for iptables.
alias itl='iptables -L -n -v --line-numbers'
alias itlf='iptables -L FORWARD -n -v --line-numbers'
alias itli='iptables -L INPUT -n -v --line-numbers'
alias nat='iptables -t nat -L -n -v --line-numbers'
