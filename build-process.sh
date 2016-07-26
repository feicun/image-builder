#！/usr/bin/expect
set tag [lindex $argv 0]
set url [lindex $argv 1]
set branch [lindex $argv 2]

spawn mkdir tmp-clone

# Clone repository
spawn git clone -b $branch --single-branch $url ./tmp-clone
expect "yes/no"
send "yes\r"
# expect "Enter passphrase for key" {
    # send "\r"
# }
expect "Checking connectivity... done."
expect eof
# expect eof # Wait for git clone complete

# Build image
spawn /root/execute.sh docker build -t $tag -f ./tmp-clone/Dockerfile ./tmp-clone
sleep 1

# expect build image successfully
expect "Successfully built" {
	spawn /root/execute.sh docker push $tag
    # expect push image successfully
	expect "size:" {
		exit 0
	}
    # 4 means push built image failed
	exit 4
}
# 5 means build failed
exit 5
