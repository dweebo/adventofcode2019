package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)

type Planet struct {
	name   string
	orbits int
}

func main() {
	data, err := ioutil.ReadFile("day6.txt")
	if err != nil {
		panic(err)
	}

	planets := make(map[string][]Planet)
	for _, line := range strings.Split(string(data), "\n") {
		if len(line) > 0 {
			base_planet := line[0:3]
			orbiting_planet := line[4:]
			planets[base_planet] = append(planets[base_planet], Planet{name: orbiting_planet, orbits: 0})
		}
	}

	queue := make([]Planet, 10)
	for _, p := range planets["COM"] {
		p.orbits = 1
		queue = append(queue, p)
	}

	total_orbits := 0
	for len(queue) > 0 {
		base_planet := queue[0]
		queue = queue[1:]
		total_orbits += base_planet.orbits
		for _, orbiting_planet := range planets[base_planet.name] {
			orbiting_planet.orbits = base_planet.orbits + 1
			queue = append(queue, orbiting_planet)
		}
	}

	fmt.Println(total_orbits)
}

// parse file into map of base planet => list of orbiting planets
// create queue of plants to process
// add all planets from Center to queue w/ orbits size=1
// while queue not empty
//   remove planet p from queue
//   total_orbits += p.orbits
//   for each planet q orbiting p (from map)
//      set q.orbits=p.orbits+1
//      add q to queue
