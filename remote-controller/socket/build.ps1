go env -w GOOS=linux
go env -w GOARCH=amd64
go build -o chym-socket
scp -r ./chym-socket yun:/root