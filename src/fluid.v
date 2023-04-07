module main

struct Fluid {
	mut:

		density []f32

}

fn (mut f Fluid) add_density(x int, y int, amount f32) {
	idx := get_idx(x, y)
	f.density[idx] += amount
}



fn init_fluid(dt f32, diffusion f32, viscosity f32) Fluid {
	mut density := []f32{}
	for i in 0..cell_amount * cell_amount {
		density << 0.0
	}

	return Fluid{
		density: density
	}
}

fn get_idx(x int, y int) int {
	return x/cell_size + y/cell_size * cell_amount
}

