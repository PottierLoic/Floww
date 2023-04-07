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
	idx := get_idx(x, y)
	f.density[idx] += amount
}

// fn (mut f Fluid) add_velocity(x int, y int, amount_x f32, amount_y f32) {
// 	idx := x + y * size
// 	f.vx[idx] += amount_x
// 	f.vy[idx] += amount_y
// }

// fn (mut f Fluid) diffuse(b int, x []f32, x0 []f32, diff f32) {
// 	a := f.dt * diff * (size - 2) * (size - 2)
// 	linear_solve(b, x, x0, a, 1 + 6 * a)
// }

fn init_fluid(dt f32, diffusion f32, viscosity f32) Fluid {
	mut s := []f32{}
	mut density := []f32{}
	mut vx := []f32{}
	mut vy := []f32{}
	mut vx0 := []f32{}
	mut vy0 := []f32{}
	for i in 0..cell_amount * cell_amount {
		density << 0.0
	}

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

fn get_idx(x int, y int) int {
	return x/cell_size + y/cell_size * cell_amount
}

// // not working yet, need to define set_bound
// fn linear_solve (b int, x []f32, x0 []f32, a f32, c f32) {
// 	c_recip := 1.0 / c
// 	for k := 0; k < 20; k++ {
// 		for j := 1; j < size - 1; j++ {
// 			for i := 1; i < size - 1; i++ {
// 				x[i + size * j] = (x0[i + size * j] + a * (x[i + 1 + size * j] + x[i - 1 + size * j] + x[i + size * (j + 1)] + x[i + size * (j - 1)])) * c_recip
// 			}
// 		}
// 		set_bnd(b, x)
// 	}
// }