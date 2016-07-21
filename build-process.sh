#！/usr/bin/expect
set tag [lindex $argv 0]
set url [lindex $argv 1]
set branch [lindex $argv 2]
spawn mkdir $tag
spawn git clone -b $branch --single-branch $url "./$tag"
spawn cd $tag
spawn /root/execute.sh docker build -t [lindex $argv 0] [lindex $argv 1]
expect "you want to continue connecting"
send "yes\n"
expect "Enter passphrase for key"
send "\n"
sleep 1
# expect build image successfully
expect "Successfully built" {
	spawn /root/execute.sh docker push [lindex $argv 0]
    # expect push image successfully
	expect "size:" {
		exit 0
	}
	exit 1
}
exit 1
