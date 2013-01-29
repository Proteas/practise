package main

import "fmt"

func main() {
	min, max := 0, 100
	fmt.Printf("请想一个%d～%d的整数。\n", min, max)
	for min < max {
		i := (min + max) / 2
		fmt.Printf("该数小于或者等于%d吗？(y/n)", i)
		var s string
		fmt.Scanf("%s", &s)
		if s != "" && s[0] == 'y' {
			max = i
		} else {
			min = i + 1
		}
	}
	fmt.Printf("该数是%d\n", max)
}
