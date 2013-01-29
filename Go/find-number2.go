package main

import (
	"fmt"
	"sort"
	)

func main() {
	fmt.Println("Pick a number from 0 to 100.")
	fmt.Printf("Your number is %d\n", 
		sort.Search(100, func(i int) bool {
		fmt.Printf("Is your number <= %d?\n", i)
		var s string
		fmt.Scanf("%s\n", &s)
		return s != "" && s[0] == 'y'
	}))
}
