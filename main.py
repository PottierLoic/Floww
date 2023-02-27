"""
Floowo simulation.
    Author: Loïc Pottier.
    Creation date: 27/02/2023.
"""

# Basic libraries.
from tkinter import *

# Constants.
BACKGROUND_COLOR = "#FFFFFF"
WIDTH = 1000
HEIGHT = 500


if __name__ == "__main__":
    window = Tk()
    window.title("Floowo")

    canvas = Canvas(window, bg=BACKGROUND_COLOR, height=HEIGHT, width=WIDTH)
    canvas.pack()
    
    window.update()

    # MAIN PART


    window.mainloop()