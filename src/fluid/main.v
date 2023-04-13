module main

import gg
import gx

import math
import rand

struct App {
mut:
	gg    &gg.Context = unsafe { nil }
	fluid Fluid = init_fluid(0.2, 0, 0.0000001)
}

fn (mut app App) display() {
	for idx in 0 .. app.fluid.density.len {
		x := idx % cell_amount
		y := idx / cell_amount
		if app.fluid.density[idx] > 0 {
			density := app.fluid.density[idx]
			app.gg.draw_rect_filled(x * cell_size, y * cell_size, cell_size, cell_size,
				gx.rgb(u8(255 * density), u8(255 * density), u8(255 * density)))
		}
	}
}

fn frame(mut app App) {
	app.gg.begin()
	app.fluid.step()
	app.display()
	app.gg.end()
}

fn click(x f32, y f32, btn gg.MouseButton, mut app App) {
	if btn == .left {
		mut angle := rand.f32() * math.pi * 2
		for i in -1..2 {
			for j in -1..2 {
				xx := i * cell_size
				yy := j * cell_size
				if x + xx >= 0 && x + xx < size && y + yy >= 0 && y + yy < size {
					app.fluid.add_density(int(x + xx), int(y + yy), 0.1)
					app.fluid.add_velocity(int(x + xx), int(y + yy), f32(math.cos(angle)), f32(math.sin(angle)))
				}
			}
		}
	}
}

fn main() {
	mut app := App{
		gg: 0
	}
	app.gg = gg.new_context(
		bg_color: background_color
		frame_fn: frame
		user_data: &app
		width: size
		height: size
		create_window: true
		resizable: false
		window_title: 'Flowoo'
		click_fn: click
	)
	app.gg.run()
}
