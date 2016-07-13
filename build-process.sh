#！/usr/bin/expect

spawn /root/execute.sh docker build -t [lindex $argv 0] [lindex $argv 1]
expect "you want to continue connecting"
send "yes\n"
expect "Enter passphrase for key"
send "\n"

exit
