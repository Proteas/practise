package main

import "fmt"

var (
	a[30000]byte
	prog = "++++++++++[>++++++++++<-]>++++.+."
	p, pc int
	)

func loop (inc int) {
	for i := inc; i != 0; pc += inc {
		switch prog[pc + inc] {
		case '[':
			i++
		case ']':
			i--
		}
	}
}

func main () {
	for {
		switch prog[pc] {
		case '>':
			p++
		case '<':
			p--
		case '+':
			a[p]++
		case '-':
			a[p]--
		case '.':
			fmt.Print(string(a[p]))
		case '[':
			if a[p] == 0 {
				loop(1)
			}
		case ']':
			if a[p] != 0 {
				loop(-1)
			}
		default:
			fmt.Println("Illegal instruction")
		}
		pc++
		if pc == len(prog) {
			return
		}
	}
}
