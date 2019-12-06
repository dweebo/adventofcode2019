package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)

type SpaceObject struct {
	name        string
	orbit_count int
	orbits      *SpaceObject
	satellites  []*SpaceObject
	transfers   []*SpaceObject
}

func (p *SpaceObject) AddSatellite(space_object *SpaceObject) {
	p.satellites = append(p.satellites, space_object)
	p.transfers = append(p.transfers, space_object)
	space_object.orbits = p
	space_object.transfers = append(space_object.transfers, p)
}

var space_objects = make(map[string]*SpaceObject)

func add_space_object(space_object_name string) *SpaceObject {
	space_object, found := space_objects[space_object_name]
	if !found {
		space_object = &SpaceObject{name: space_object_name}
		space_objects[space_object.name] = space_object
		return space_object
	} else {
		return space_object
	}
}

func main() {
	data, err := ioutil.ReadFile("day6.txt")
	if err != nil {
		panic(err)
	}

	for _, line := range strings.Split(string(data), "\n") {
		if len(line) > 0 {
			base_space_object := add_space_object(line[0:3])
			orbiting_space_object := add_space_object(line[4:])
			base_space_object.AddSatellite(orbiting_space_object)
		}
	}

	queue := make([]*SpaceObject, 0, 10)
	for _, p := range space_objects["COM"].satellites {
		p.orbit_count = 1
		queue = append(queue, p)
	}

	total_orbits := 0
	for len(queue) > 0 {
		base_space_object := queue[0]
		queue = queue[1:]
		total_orbits += base_space_object.orbit_count
		x := space_objects[base_space_object.name]
		for _, orbiting_space_object := range x.satellites {
			orbiting_space_object.orbit_count = base_space_object.orbit_count + 1
			queue = append(queue, orbiting_space_object)
		}
	}

	fmt.Println(total_orbits)
}

func part1() {
}

// parse file into map of base space_object => list of orbiting space_objects
// create queue of plants to process
// add all space_objects from Center to queue w/ orbits size=1
// while queue not empty
//   remove space_object p from queue
//   total_orbits += p.orbits
//   for each space_object q orbiting p (from map)
//      set q.orbits=p.orbits+1
//      add q to queue
//171213

// part 2
// make it more of a graph and do depth-first-search
