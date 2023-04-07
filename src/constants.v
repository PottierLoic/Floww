module main

import gx

const (
	background_color = gx.black

	size = 800
	cell_size = 10
	cell_amount = size / cell_size

	iter = 10

	// Simulation parameters (probably not staying in const as I want to be able to change them)
	diffusion = 0.5

)