module main

import math

struct Field {
	mut:
		angles [][]f32
}

fn (mut f Field) update(rotate bool) {
	f.modulo_angles()
	if rotate {
		f.rotate()
	}
}

fn (mut f Field) rotate() {
	for x := 0; x < cell_amount; x++ {
		for y := 0; y < cell_amount; y++ {
			f.angles[x][y] += 0.01
		}
	}
}

fn (mut f Field) modulo_angles() {
	for x := 0; x < cell_amount; x++ {
		for y := 0; y < cell_amount; y++ {
			f.angles[x][y] = f32(math.mod(f.angles[x][y], 2 * math.pi))
		}
	}
}

fn (mut f Field) point_at(x f32, y f32) {
	idx, idy := get_index(x, y)
	for xx := 0; xx < size; xx++ {
		for yy := 0; yy < size; yy++ {
			idxx, idyy := get_index(f32(xx), f32(yy))

			xy_angle := f32(math.atan2(f32(yy - y), f32(xx - x)))
			distance := f32(math.sqrt(f32((xx - x) * (xx - x) + (yy - y) * (yy - y))))
			percent := (influence_dist - distance) / influence_dist
			gap := xy_angle - f.angles[idxx][idyy]
			if percent > 0 {
				f.angles[idxx][idyy] += gap * percent
			}
		}
	}
}

fn init_field() Field {
	mut angles := [][]f32{}

	for x := 0; x < cell_amount; x++ {
		mut row := []f32{}
		for y := 0; y < cell_amount; y++ {
			row << f32(0)
		}
		angles << row
	}

	return Field{
		angles: angles
	}
}

fn get_index(x f32, y f32) (int, int) {
	return int(x/cell_size), int(y/cell_size)
}