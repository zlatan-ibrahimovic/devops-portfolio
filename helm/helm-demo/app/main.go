package main
import (
  "fmt"
  "log"
  "net/http"
  "os"
)
func main() {
  msg := os.Getenv("WELCOME_MESSAGE")
  http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "<h1>%s</h1>", msg)
  })
  log.Println("listening on :8080")
  http.ListenAndServe(":8080", nil)
}
