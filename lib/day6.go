package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)

type Planet struct {
	name     string
	orbits   int
	parent   *Planet
	children []*Planet
}

func (p *Planet) AddLink(planet *Planet) {
	p.children = append(p.children, planet)
	planet.parent = p
}

var planets = make(map[string]*Planet)

func add_planet(planet_name string) *Planet {
	planet, found := planets[planet_name]
	if !found {
		planet = &Planet{name: planet_name}
		planets[planet.name] = planet
		return planet
	} else {
		return planet
	}
}

func main() {
	data, err := ioutil.ReadFile("day6.txt")
	if err != nil {
		panic(err)
	}

	for _, line := range strings.Split(string(data), "\n") {
		if len(line) > 0 {
			base_planet := add_planet(line[0:3])
			orbiting_planet := add_planet(line[4:])
			base_planet.AddLink(orbiting_planet)
		}
	}

	queue := make([]*Planet, 0, 10)
	for _, p := range planets["COM"].children {
		p.orbits = 1
		queue = append(queue, p)
	}

	total_orbits := 0
	for len(queue) > 0 {
		base_planet := queue[0]
		queue = queue[1:]
		total_orbits += base_planet.orbits
		x := planets[base_planet.name]
		for _, orbiting_planet := range x.children {
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
//171213

// part 2
// make it more of a graph and do depth-first-search
