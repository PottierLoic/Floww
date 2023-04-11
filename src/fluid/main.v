module main

import gg
import gx

struct App {
	mut:
		gg &gg.Context = unsafe { nil }
		fluid Fluid
}

fn (mut app App) display() {
	for idx in 0 .. app.fluid.density.len {
		x := idx % cell_amount
		y := idx / cell_amount
		if app.fluid.density[idx] > 0 {
			density := app.fluid.density[idx]
			app.gg.draw_rect_filled(x*cell_size, y*cell_size, cell_size, cell_size, gx.rgb(u8(255*density), u8(255*density), u8(255*density)))
		}
	}
}

fn frame(mut app App) {
	app.gg.begin()
	app.display()
	app.gg.end()
}

fn click(x f32, y f32, btn gg.MouseButton, mut app App) {
	if btn == .left {
		println("Left click at $x, $y")
		app.fluid.add_density(int(x), int(y), 0.1)
	}
}

fn main() {
	mut app := App{
		gg: 0
		fluid: init_fluid(0, 0, 0)
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
