#！/usr/bin/expect

# spawn sudo [lrange $argv 0 4]
spawn /root/execute.sh docker build -t [lindex $argv 0] [lindex $argv 1]
# spawn [lrange $argv 0 0]
expect "you want to continue connecting"
send "yes\n"
expect "Enter passphrase for key"
send "\n"
exec sleep 60
# spawn sudo [lindex $argv 4]
# spawn ./execute.sh docker push [lindex $argv 3]
# interact
# exit
