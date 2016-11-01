package main

import (
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load("/app/.env")
	if err != nil {
		log.Fatalln("Error loading .env file")
	}

	url := strings.Join([]string{"https://www.google.com/#safe=active&q=", os.Getenv("QUERY")}, "")
	log.Println("Querying:", url)

	resp, err := http.Get(url)
	if err != nil {
		log.Fatalln(err)
	}

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln(err)
	}

	log.Println(len(body))
}
