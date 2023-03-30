module main


struct Fluid {
	mut:
		dt f32
		diff f32
		visc f32

		s []f32
		density []f32

		vx []f32
		vy []f32

		vx0 []f32
		vy0 []f32
}

fn (mut f Fluid) add_density(x int, y int, amount f32) {
	idx := x + y * size
	f.density[idx] += amount
}

fn (mut f Fluid) add_velocity(x int, y int, amount_x f32, amount_y f32) {
	idx := x + y * size
	f.vx[idx] += amount_x
	f.vy[idx] += amount_y
}

fn new_fluid(dt f32, diffusion f32, viscosity f32) Fluid {
	mut s := []f32{}
	mut density := []f32{}
	mut vx := []f32{}
	mut vy := []f32{}
	mut vx0 := []f32{}
	mut vy0 := []f32{}
	return Fluid{
		dt: dt
		diff: diffusion
		visc: viscosity
		s: s
		density: density
		vx: vx
		vy: vy
		vx0: vx0
		vy0: vy0
	}
}