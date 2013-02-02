package main

import (
	"flag"
	"fmt"
	"html"
	"io/ioutil"
	"os"
	"strings"
	)

var (
	esc = html.EscapeString
	tflag *bool = flag.Bool("html", true, "html output")
	)

func main() {
	flag.Parse()
	
	in, _ := ioutil.ReadAll(os.Stdin)
	out := parse(string(in))
	for i := range out {
		fmt.Println(out[i])
	}
}

func parse(in string)[]string {
	s := strings.Split(in, "\n\n")
	for i := 0; i < len(s); i++ {
		t := s[i]
		if t == "" {
			continue
		}
		if t[0] == '\n' {
			t = t[1:]
		}
		if (len(t) < 4) {
			s[i] = para(t)
			continue
		}
		switch t[:2] {
		default:
			s[i] = para(t)
		case "01":
			s[i] = header(t)
		case "02":
			s[i] = importFile(t)
		}
	}
	return s
}

func para(s string) string {
	if !*tflag {
		return s
	}
	s = esc(s)
	if s[0] == ' ' || s[0] == '\t' {
		s = strings.Replace(s, "\t", "    ", -1)
		return "<pre>" + s + "</pre>"
	}
	return "<p>" + s + "</p>"
}

func header(s string) string {
	if !*tflag {
		return "\t" + s[4:]
	}
	t := string(s[2])
	s = esc(s[4:])

	s = "<h" + t + ">" + s + "</h" + t + ">"
	return s
}

func importFile(s string) string {
	b, err := ioutil.ReadFile(s[4:])

	var t string
	if err != nil {
		t = fmt.Sprintf("Error: %v", err)
	} else {
		t = string(b)
	}
	return para(t)
}

