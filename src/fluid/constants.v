module main

import gx

const (
	background_color = gx.black

	size             = 400
	cell_size        = 10
	cell_amount      = size / cell_size

	// Simulation parameters (probably not staying in const as I want to be able to change them in real time)
	diffusion        = 0.5
	iter             = 10
)
