#！/usr/bin/expect

spawn /root/execute.sh docker build -t [lindex $argv 0] [lindex $argv 1]
expect "you want to continue connecting"
send "yes\n"
expect "Enter passphrase for key"
send "\n"
sleep 1
expect "Successfully built" {
	spawn /root/execute.sh docker push [lindex $argv 0]
	expect "size:" {
		exit 0
	}
	exit 1
}
exit 1
