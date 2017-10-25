package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"

	"github.com/elazarl/goproxy"
)

func main() {
	portStr := os.Getenv("PROXY_PORT")
	var port int
	if portStr == "" {
		port = 8123
	} else {
		var err error
		port, err = strconv.Atoi(portStr)
		if err != nil {
			panic(err)
		}
	}

	verbose := os.Getenv("PROXY_VERBOSE") != ""
	proxy := goproxy.NewProxyHttpServer()
	proxy.Verbose = verbose
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", port), proxy))
}
