module main

struct Fluid {
	mut:
		density []f32

		vel_x []f32
		vel_y []f32

		vel_x_0 []f32
		vel_y_0 []f32
	
		diffusion f32
		viscosity f32
}

fn (mut f Fluid) add_density(x int, y int, amount f32) {
	idx := get_idx(x, y)
	f.density[idx] += amount
}

fn (mut f Fluid) add_velocity(x int, y int, amount_x f32, amount_y f32) {
	idx := get_idx(x, y)
	f.vel_x[idx] += amount_x
	f.vel_y[idx] += amount_y
}

fn (mut f Fluid) diffuse(b int, x f32) {
	print("diffusion")
}

fn init_fluid(dt f32, diffusion f32, viscosity f32) Fluid {
	mut density := []f32{}
	mut vel_x := []f32{}
	mut vel_y := []f32{}
	mut vel_x_0 := []f32{}
	mut vel_y_0 := []f32{}
	for _ in 0..cell_amount * cell_amount {
		density << 0.0
		vel_x << 0.0
		vel_y << 0.0
		vel_x_0 << 0.0
		vel_y_0 << 0.0
	}

	return Fluid{
		density: density
		diffusion: diffusion
		viscosity: viscosity
		vel_x: vel_x
		vel_y: vel_y
		vel_x_0: vel_x_0
		vel_y_0: vel_y_0
	}
}

fn get_idx(x int, y int) int {
	return x/cell_size + y/cell_size * cell_amount
}

