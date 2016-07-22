#！/usr/bin/expect
set tag [lindex $argv 0]
set url [lindex $argv 1]
set branch [lindex $argv 2]

spawn mkdir tmp-clone

# Clone repository
spawn git clone -b $branch --single-branch $url ./tmp-clone
expect {
    "you want to continue connecting" {send "yes\r"}
    .*
}
# expect "Enter passphrase for key" {
    # send "\r"
# }
expect {
    "Checking connectivity... done."
    .* {exit 3} # 3 means clone repository failed
}
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
	exit 4 # 4 means push built image failed
}
exit 5 # 5 means build failed
