package main

import (
	"fmt"
	"log"
	"os"
	"strings"
)

const ASCII_TABLE = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"

func main() {
	file, err := os.Create(os.Args[1])
	if err != nil { log.Fatal(err) }
	defer file.Close()

	set := []rune(os.Args[2])
	if len(set) > 418 { log.Fatal("Too many characters!") }

	ascii := []rune(ASCII_TABLE)
	if len(set) < 32 {
		fmt.Fprint(os.Stderr, "There are less than 32 characters!\nPSF needs ASCII at standard offset.\nSupplementing with null...\n")
		set = append(
			set,
			append(
				[]rune(strings.Repeat("\x00", 32 - len(set))),
				ascii...,
			)...,
		)
	} else if len(set) > 32 {
		trailSet := set[32:]
		set = append(
			set[:32],
			append(
				ascii,
				trailSet...,
			)...,
		)
	} else {
		set = append(set, ascii...)
	}

	for _, c := range set {
		if c == '\n' { break }
		fmt.Fprintf(file, "%U\n", c)
	}
}

