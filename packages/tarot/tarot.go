package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {
	cards := []string{
		"0 The Fool",
		"I The Magician",
		"II The High Priestess",
		"III The Empress",
		"IV The Emperor",
		"V The Hierophant",
		"VI The Lovers",
		"VII The Chariot",
		"VIII Strength",
		"IX The Hermit",
		"X Wheel of Fortune",
		"XI Justice",
		"XII The Hanged Man",
		"XIII Death",
		"XIV Temperance",
		"XV The Devil",
		"XVI The Tower",
		"XVII The Star",
		"XVIII The Moon",
		"XIX The Sun",
		"XX Judgement",
		"XXI The World",
	}

	for _ = range 3 {
		index := rand.New(rand.NewSource(time.Now().UnixMicro())).Int() % len(cards)
		fmt.Printf("%s, %s\n", cards[index], []string{"Upright","Reversed"}[index % 2])
	}
}

