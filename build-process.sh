#！/usr/bin/expect
set tag [lindex $argv 0]
set url [lindex $argv 1]
set branch [lindex $argv 2]

spawn mkdir tmp-clone

# Clone repository
spawn git clone -b $branch --single-branch $url ./tmp-clone
# Deal with connect to SSH server with private key prompt
# "Are you sure you want to continue connecting"
expect "yes/no" {send "yes\n"}
wait

# Build image
spawn /root/execute.sh docker build -t $tag -f ./tmp-clone/Dockerfile ./tmp-clone
set pidclone [exp_pid]
wait pidclone

# expect build image successfully
expect "Successfully built" {
	spawn /root/execute.sh docker push $tag
    set pidpush [exp_pid]
    wait pidpush
    # expect push image successfully
	expect "size:" {
		exit 0
	}
    expect eof
    # 4 means push built image failed
	exit 4
}
# 5 means build failed
exit 5
