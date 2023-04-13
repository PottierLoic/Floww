module main

import math

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

fn (mut f Fluid) diffuse(b int, mut x []f32, x_0 []f32, diff f32) {
	a := f.dt * diff * (cell_amount - 2) * (cell_amount - 2)
	lin_solve(b, mut x, x_0, a, 1 + 6 * a)
}

fn (mut f Fluid) project(mut vel_x []f32, mut vel_y []f32, mut p []f32, mut div []f32) {
	for j := 1; j < cell_amount - 1; j++ {
		for i := 1; i < cell_amount - 1; i++ {
			div[get_idx(i, j)] = -0.5 * (vel_x[get_idx(i + 1, j)] - vel_x[get_idx(i - 1, j)] + vel_y[get_idx(i, j + 1)] - vel_y[get_idx(i, j - 1)]) / cell_amount
			p[get_idx(i, j)] = 0
		}
	}
	set_bnd(0, mut div)
	set_bnd(0, mut p)
	lin_solve(0, mut p, div, 1, 6)

	for j := 1; j < cell_amount - 1; j++ {
		for i := 1; i < cell_amount - 1; i++ {
			vel_x[get_idx(i, j)] -= 0.5 * (p[get_idx(i + 1, j)] - p[get_idx(i - 1, j)]) * cell_amount
			vel_y[get_idx(i, j)] -= 0.5 * (p[get_idx(i, j + 1)] - p[get_idx(i, j - 1)]) * cell_amount
		}
	}
	set_bnd(1, mut vel_x)
	set_bnd(2, mut vel_y)
}

fn (mut f Fluid) advect(b int, mut d []f32, d_0 []f32, vel_x []f32, vel_y []f32) {
	dt0 := f.dt * (cell_amount - 2)
	for j := 1; j < cell_amount - 1; j++ {
		for i := 1; i < cell_amount - 1; i++ {
			mut x := i - dt0 * vel_x[get_idx(i, j)]
			mut y := j - dt0 * vel_y[get_idx(i, j)]
			if x < 0.5 {
				x = 0.5
			}
			if x > cell_amount + 0.5 {
				x = cell_amount + 0.5
			}
			i0 := int(math.floor(x))
			i1 := i0 + 1
			if y < 0.5 {
				y = 0.5
			}
			if y > cell_amount + 0.5 {
				y = cell_amount + 0.5
			}
			j0 := int(math.floor(y))
			j1 := j0 + 1
			s1 := x - i0
			s0 := 1 - s1
			t1 := y - j0
			t0 := 1 - t1
			d[get_idx(i, j)] = s0 * (t0 * d_0[get_idx(i0, j0)] + t1 * d_0[get_idx(i0, j1)]) + s1 * (t0 * d_0[get_idx(i1, j0)] + t1 * d_0[get_idx(i1, j1)])
		}
	}
	set_bnd(b, mut d)
}


fn (mut f Fluid) step() {
	println("step:\n")
	// f.diffuse(1, mut f.vel_x_0, f.vel_x, f.visc)
	// f.diffuse(2, mut f.vel_y_0, f.vel_y, f.visc)

	// f.project(mut f.vel_x_0, mut f.vel_y_0, mut f.vel_x, mut f.vel_y)

	// f.advect(1, mut f.vel_x, f.vel_x_0, f.vel_x_0, f.vel_y_0)
	// f.advect(2, mut f.vel_y, f.vel_y_0, f.vel_x_0, f.vel_y_0)

	// f.project(mut f.vel_x, mut f.vel_y, mut f.vel_x_0, mut f.vel_y_0)

	f.diffuse(0, mut f.s, f.density, f.diff)
	f.density = f.s
	// f.advect(0, mut f.density, f.s, f.vel_x, f.vel_y)
	f.print_density()

}

fn (f Fluid) print_density() {
	for i in 0..cell_amount {
		for j in 0..cell_amount {
			print("${f.density[i * cell_amount + j]} ")
		}
		println("")
	}
}

fn (f Fluid) print_velocity() {
	for i in 0..cell_amount {
		for j in 0..cell_amount {
			print("${f.vel_x[i * cell_amount + j]} ")
		}
		println("")
	}
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

fn lin_solve(b int, mut x []f32, x_0 []f32, a f32, c f32) {
	c_recip := 1.0 / c
	for k := 0; k < 20; k++ {
		for j := 1; j < cell_amount - 1; j++ {
			for i := 1; i < cell_amount - 1; i++ {
				x[get_idx(i, j)] = (x_0[get_idx(i, j)] + a * (x[get_idx(i + 1, j)] + x[get_idx(i - 1, j)] + x[get_idx(i, j + 1)] + x[get_idx(i, j - 1)])) * c_recip
			}
		}
		set_bnd(b, mut x)
	}
}

fn set_bnd(b int, mut x []f32) {
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
