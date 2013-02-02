package main

import (
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"
	"strconv"
	)

var uniq = make(chan int)

func init() {
	go func() {
		for i := 0; ; i++ {
			uniq <- i
		}
	}()
}

func main() {
	if err := os.Chdir(os.TempDir()); err != nil {
		log.Fatal(err)
	}

	http.HandleFunc("/", FrontPage)
	http.HandleFunc("/compile", Compile)
	log.Fatal(http.ListenAndServe("127.0.0.1:4321", nil))
}

func FrontPage (w http.ResponseWriter, _ *http.Request) {
	w.Write([]byte(frontPage))
}

func err(w http.ResponseWriter, e error) bool {
	if e != nil {
		w.Write([]byte(e.Error()))
		return true
	}
	return false
}

func Compile(w http.ResponseWriter, req *http.Request) {
	x := "play_" + strconv.Itoa(<-uniq) + ".go"
	
	f, e := os.Create(x)
	if err(w, e) {
		return
	}
	
	defer os.Remove(x)
	defer f.Close()

	_, e = io.Copy(f, req.Body)
	if err(w, e) {
		return
	}
	f.Close()

	cmd := exec.Command("go", "run", x)
	o, e := cmd.CombinedOutput()
	if err(w, e) {
		return
	}
	w.Write(o)
}

const frontPage = `<!doctype html>
<html>
  <head>
    <script>
      var req;
      function compile() {
        var prog = document.getElementById("edit").value;
        var req = new XMLHttpRequest();
        req.onreadystatechange = function() {
          if (!req || req.readyState != 4) 
             return;
          document.getElementById("output").innerHTML = req.responseText;
        }
        req.open("POST", "/compile", true);
        req.setRequestHeader("Content-Type", "text/plain; charset = utf-8")
        req.send(prog);
      }
    </script>
  </head>
  <body>
    <textarea rows = "25" cols = "80" id = "edit" spellcheck = "false">
      package main
      import "fmt"
      func main() {
        fmt.Println("hello, world")
      }
    </textarea>
    <button onclick="compile();">run</button>
    <div id = "output"></div>
  </body>
</html>
`
