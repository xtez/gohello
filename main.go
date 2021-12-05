package main

import (
	"fmt"
	"log"
	"net/http"
)

func printHello(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Hello, World")
}

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/hello", printHello)

	log.Fatal(http.ListenAndServe(":80", mux))
}
