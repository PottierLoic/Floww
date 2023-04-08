module main

import math

struct Field {
	mut:
		angles [][]f32
		lenghts [][]f32
}

fn (mut f Field) update() {
	f.modulo_angles()
}

fn (mut f Field) rotate() {
	for x := 0; x < cell_amount; x++ {
		for y := 0; y < cell_amount; y++ {
			f.angles[x][y] += math.pi/2
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
	for xx := 0; xx < size; xx++ {
		for yy := 0; yy < size; yy++ {
			idxx, idyy := get_index(f32(xx), f32(yy))

			xy_angle := f32(math.atan2(f32(yy - y), f32(xx - x)))
			distance := f32(math.sqrt(f32((xx - x) * (xx - x) + (yy - y) * (yy - y))))
			percent := (influence_dist - distance) / influence_dist
			gap := xy_angle - f.angles[idxx][idyy]
			if percent > 0 {
				f.angles[idxx][idyy] += gap * percent
				f.lenghts[idxx][idyy] = (cell_size/2)*percent
			} 
			if f.lenghts[idxx][idyy] < 2 {
				f.lenghts[idxx][idyy] = 2
			}
		}
	}
}

fn init_field() Field {
	mut angles := [][]f32{}
	mut lenghts := [][]f32{}

	for x := 0; x < cell_amount; x++ {
		mut row := []f32{}
		mut row2 := []f32{}
		for y := 0; y < cell_amount; y++ {
			row << f32(0)
			row2 << f32(2)
		}
		angles << row
		lenghts << row2
	}

	return Field{
		angles: angles
		lenghts: lenghts
	}
}

fn get_index(x f32, y f32) (int, int) {
	return int(x/cell_size), int(y/cell_size)
}