module main

import math

import gg
import gx

const (
	size = 800
	background_color = gx.black
)

struct App {
	mut:
		gg &gg.Context = unsafe { nil }
		field Field
}

fn (mut app App) display() {
	for x in 0 .. cell_amount {
		for y in 0 .. cell_amount {
			ang := app.field.angles[x][y]
			px := x * cell_size + cell_size / 2
			py := y * cell_size + cell_size / 2
			app.gg.draw_line(px, py, f32(px + cell_size / 2 * math.cos(ang)), f32(py + cell_size / 2 * math.sin(ang)), gx.white)
		}
	}
}

fn frame(mut app App) {
	app.gg.begin()
	app.display()
	app.field.point_at(app.gg.mouse_pos_x, app.gg.mouse_pos_y)
	app.field.update()
	app.gg.end()
}

fn click(x f32, y f32, btn gg.MouseButton, mut app App) {
	if btn == .left {
		println("Left click at $x, $y")
		app.field.point_at(x, y)
	}
}

fn main() {
	mut app := App{
		gg: 0
		field: init_field()
	}
	app.gg = gg.new_context(
		bg_color: background_color
		frame_fn: frame
		user_data: &app
		width: size
		height: size
		create_window: true
		resizable: false
		window_title: 'vector fields'
		click_fn: click
	)

	app.gg.run()
}
