"""
Grid class.
    Author: Loïc Pottier.
    Creation date: 27/02/2023.
"""

# Basic libraries
import numpy as np

# Local libraries
from cell import Cell

# Constants.
BACKGROUND_COLOR = "#FFFFFF"
GRID_WIDTH = 200
GRID_HEIGHT = 100


class Grid():
    def __init__(self) -> None:
        self.grid = np.zeros((100, 200), dtype=np.object)
        for x in range(GRID_WIDTH):
            for y in range(GRID_HEIGHT):
                self.grid[y][x] = Cell()

    def add(self):
        pass

    def update(self):
        pass