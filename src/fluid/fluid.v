module main

struct Fluid {
mut:
	density []f32
	s 		[]f32

	vel_x []f32
	vel_y []f32

	vel_x_0 []f32
	vel_y_0 []f32

	dt   f32
	diff f32
	visc f32
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

fn (mut f Fluid) diffuse(b int, mut x []f32, x0 []f32, diff f32) {
	a := f.dt * diff * (cell_amount - 2) * (cell_amount - 2)
	f.linear_solve(b, mut x, x0, a, 1 + 6 * a)
}

fn (mut f Fluid) linear_solve(b int, mut x []f32, x0 []f32, a f32, c f32) {
	c_recip := 1.0 / c
	for k := 0; k < 20; k++ {
		for j := 1; j < cell_amount - 1; j++ {
			for i := 1; i < cell_amount - 1; i++ {
				x[get_idx(i, j)] = (x0[get_idx(i, j)] + a * (x[get_idx(i + 1, j)] + x[get_idx(i - 1, j)] + x[get_idx(i, j + 1)] + x[get_idx(i, j - 1)])) * c_recip
			}
		}
		f.set_bnd(b, mut x)
	}
}

fn (mut f Fluid) set_bnd(b int, mut x []f32) {
	for i := 1; i < cell_amount - 1; i++ {
		if b == 2 {
			x[get_idx(i, 0)] = -x[get_idx(i, 1)]
			x[get_idx(i, cell_amount - 1)] = -x[get_idx(i, cell_amount - 2)]
		} else {
			x[get_idx(i, 0)] = x[get_idx(i, 1)]
			x[get_idx(i, cell_amount - 1)] = x[get_idx(i, cell_amount - 2)]
		}
	}

	for j := 1; j < cell_amount - 1; j++ {
		if b == 1 {
			x[get_idx(0, j)] = -x[get_idx(1, j)]
			x[get_idx(cell_amount - 1, j)] = -x[get_idx(cell_amount - 2, j)]
		} else {
			x[get_idx(0, j)] = x[get_idx(1, j)]
			x[get_idx(cell_amount - 1, j)] = x[get_idx(cell_amount - 2, j)]
		}
	}

	x[get_idx(0, 0)] = 0.5 * (x[get_idx(1, 0)] + x[get_idx(0, 1)])
	x[get_idx(0, cell_amount - 1)] = 0.5 * (x[get_idx(1, cell_amount - 1)] + x[get_idx(0, cell_amount - 2)])
	x[get_idx(cell_amount - 1, 0)] = 0.5 * (x[get_idx(cell_amount - 2, 0)] + x[get_idx(cell_amount - 1, 1)])
	x[get_idx(cell_amount - 1, cell_amount - 1)] = 0.5 * (x[get_idx(cell_amount - 2, cell_amount - 1)] + x[get_idx(cell_amount - 1, cell_amount - 2)])
}

fn (mut f Fluid) step () {
	f.diffuse(0, mut f.s, f.density, f.visc)
}

fn init_fluid(dt f32, diffusion f32, viscosity f32) Fluid {
	mut density := []f32{}
	mut s := []f32{}
	mut vel_x := []f32{}
	mut vel_y := []f32{}
	mut vel_x_0 := []f32{}
	mut vel_y_0 := []f32{}
	for _ in 0 .. cell_amount * cell_amount {
		density << 0.0
		s << 0.0
		vel_x << 0.0
		vel_y << 0.0
		vel_x_0 << 0.0
		vel_y_0 << 0.0
	}

	return Fluid{
		density: density
		s: s
		diff: diffusion
		visc: viscosity
		dt: dt
		vel_x: vel_x
		vel_y: vel_y
		vel_x_0: vel_x_0
		vel_y_0: vel_y_0
	}
}

fn get_idx(x int, y int) int {
	return x / cell_size + y / cell_size * cell_amount
}
