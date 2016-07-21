#！/usr/bin/expect
set tag [lindex $argv 0]
set url [lindex $argv 1]
set branch [lindex $argv 2]
spawn mkdir tmp-clone
spawn /root/execute.sh git clone -b $branch --single-branch $url ./tmp-clone
spawn /root/execute.sh docker build -t $tag -f ./tmp-clone/Dockerfile ./tmp-clone
expect "you want to continue connecting"
send "yes\n"
expect "Enter passphrase for key"
send "\n"
sleep 1
# expect build image successfully
expect "Successfully built" {
	spawn /root/execute.sh docker push $tag
    # expect push image successfully
	expect "size:" {
		exit 0
	}
	exit 1
}
exit 1
