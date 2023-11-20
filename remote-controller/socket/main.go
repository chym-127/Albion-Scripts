// websockets.go
package main

import (
	"fmt"
	"net/http"

	"github.com/gorilla/websocket"
	uuid "github.com/satori/go.uuid"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}
var messages = make(chan []byte)
var sessions = make(map[string]*websocket.Conn)

func read(conn *websocket.Conn, uuid string) {
	for {
		_, msg, err := conn.ReadMessage()
		if err != nil {
			return
		}
		messages <- msg
	}
}

// 发送消息
func notify() {
	for {
		message, ok := <-messages
		if !ok {
			break
		}
		for _, conn := range sessions {
			_ = conn.WriteMessage(websocket.TextMessage, message)
		}
	}
}

func main() {
	http.HandleFunc("/ws", func(w http.ResponseWriter, r *http.Request) {
		conn, err := upgrader.Upgrade(w, r, nil) // error ignored for sake of simplicity
		if err != nil {
			fmt.Println(err)
			return
		}
		uuid := uuid.Must(uuid.NewV4(), nil).String()
		sessions[uuid] = conn

		go read(conn, uuid)
	})

	go notify()

	http.ListenAndServe(":8080", nil)
}
