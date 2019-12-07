package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)

type SpaceObject struct {
	name       string
	counter    int
	orbits     *SpaceObject
	satellites []*SpaceObject
	transfers  []*SpaceObject
	visited    bool
}

func (space_object *SpaceObject) AddSatellite(satellite *SpaceObject) {
	space_object.satellites = append(space_object.satellites, satellite)
	space_object.transfers = append(space_object.transfers, satellite)
	satellite.orbits = space_object
	satellite.transfers = append(satellite.transfers, space_object)
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
	parse()
	part1()
	part2()
}

func parse() {
	data, err := ioutil.ReadFile("day6.txt")
	if err != nil {
		panic(err)
	}

	for _, line := range strings.Split(string(data), "\n") {
		if len(line) > 0 {
			space_object := add_space_object(strings.Split(line, ")")[0])
			satellite := add_space_object(strings.Split(line, ")")[1])
			space_object.AddSatellite(satellite)
		}
	}
}

func part1() {
	queue := make([]*SpaceObject, 0, 10)
	for _, satellite := range space_objects["COM"].satellites {
		satellite.counter = 1
		queue = append(queue, satellite)
	}

	total_orbits := 0
	for len(queue) > 0 {
		space_object := queue[0]
		queue = queue[1:]
		total_orbits += space_object.counter
		for _, satellite := range space_object.satellites {
			satellite.counter = space_object.counter + 1
			queue = append(queue, satellite)
		}
	}

	fmt.Println(total_orbits)
}

func part2() {
	you := space_objects["YOU"]
	tranfers := part2_dfs(you, 0)
	fmt.Printf("%d\n", (tranfers - 2))
}

func part2_dfs(space_object *SpaceObject, transfers int) int {
	space_object.visited = true

	if space_object.name == "SAN" {
		return transfers
	}

	for _, next_space_object := range space_object.transfers {
		if !next_space_object.visited {
			result := part2_dfs(next_space_object, transfers+1)
			if result != -1 {
				return result
			}
		}
	}

	return -1
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
//292
