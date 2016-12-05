# -*- coding: utf-8 -*-
#
# 2016/12/04
#

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.lines as lines
import matplotlib.patches as mpatches

class Soccerfield:

    """
    Draws a line.
      @param plot
      @param startX
      @param startY
      @param endX
      @param endY
    """
    def drawLine(self, plot, startX, startY, endX, endY, lineWidth, color):
        line = [(startX, startY), (endX, endY)]
        (line_xs, line_ys) = zip(*line)
        plot.add_line(lines.Line2D(line_xs, line_ys, linewidth=lineWidth, color=color, zorder=1))

    """
    Creates the soccerfield.
    """
    def __init__(self, home_datas):
        fig, ax = plt.subplots()

        fig.patch.set_facecolor('green')
        fig.patch.set_alpha(0.7)

        plt.axis('off')

        fieldLinesColor = 'white'
        fieldLinesWitdh = 1

        # Field size
        fieldStartX = 10
        fieldStartY = 10
        fieldWidth  = 100
        fieldHeight = 80

        # Field lines
        self.drawLine(ax, fieldStartX, fieldStartY, fieldStartX+fieldWidth, fieldStartY, fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, fieldStartX, fieldStartY+fieldHeight, fieldStartX+fieldWidth, fieldStartY+fieldHeight, fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, fieldStartX, fieldStartY, fieldStartX, fieldStartY+fieldHeight, fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, fieldStartX+fieldWidth, fieldStartY, fieldStartX+fieldWidth, fieldStartY+fieldHeight, fieldLinesWitdh, fieldLinesColor)
        # Penalty area 1
        self.drawLine(ax, fieldStartX, fieldStartY+(fieldHeight/4.77), fieldStartX+(fieldWidth*0.17), fieldStartY+(fieldHeight/4.77), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, fieldStartX+(fieldWidth*0.17), fieldStartY+(fieldHeight/4.77), fieldStartX+(fieldWidth*0.17), fieldStartY+(fieldHeight/1.26), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, fieldStartX+(fieldWidth*0.17), fieldStartY+(fieldHeight/1.26), fieldStartX, fieldStartY+(fieldHeight/1.26), fieldLinesWitdh, fieldLinesColor)
        # GK area 1
        self.drawLine(ax, fieldStartX, fieldStartY+(fieldHeight/2.71), fieldStartX+(fieldWidth*0.05), fieldStartY+(fieldHeight/2.71), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, fieldStartX+(fieldWidth*0.05), fieldStartY+(fieldHeight/2.71), fieldStartX+(fieldWidth*0.05), fieldStartY+(fieldHeight/1.58), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, fieldStartX+(fieldWidth*0.05), fieldStartY+(fieldHeight/1.58), fieldStartX, fieldStartY+(fieldHeight/1.58), fieldLinesWitdh, fieldLinesColor)
        # Midfield
        self.drawLine(ax, fieldStartX+(fieldWidth/2), fieldStartY, fieldStartX+(fieldWidth/2), fieldStartY+(fieldHeight), fieldLinesWitdh, fieldLinesColor)
        # Penalty area 2
        self.drawLine(ax, fieldStartX+fieldWidth, fieldStartY+(fieldHeight/4.77), fieldStartX+(fieldWidth-fieldWidth*0.17), fieldStartY+(fieldHeight/4.77), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, fieldStartX+(fieldWidth-fieldWidth*0.17), fieldStartY+(fieldHeight/4.77), fieldStartX+(fieldWidth-fieldWidth*0.17), fieldStartY+(fieldHeight/1.26), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, fieldStartX+(fieldWidth-fieldWidth*0.17), fieldStartY+(fieldHeight/1.26), fieldStartX+fieldWidth, fieldStartY+(fieldHeight/1.26), fieldLinesWitdh, fieldLinesColor)
        # GK area 2
        self.drawLine(ax, fieldStartX+fieldWidth, fieldStartY+(fieldHeight/2.71), fieldStartX+(fieldWidth-fieldWidth*0.05), fieldStartY+(fieldHeight/2.71), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, fieldStartX+(fieldWidth-fieldWidth*0.05), fieldStartY+(fieldHeight/2.71), fieldStartX+(fieldWidth-fieldWidth*0.05), fieldStartY+(fieldHeight/1.58), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, fieldStartX+(fieldWidth-fieldWidth*0.05), fieldStartY+(fieldHeight/1.58), fieldStartX+fieldWidth, fieldStartY+(fieldHeight/1.58), fieldLinesWitdh, fieldLinesColor)
        # Center circle
        centerCircle = plt.Circle((fieldStartX+(fieldWidth/2), fieldStartY+(fieldHeight/2)), 12, color=fieldLinesColor, fill=False)
        ax.add_artist(centerCircle)
        # Engaging point
        engagingPoint = plt.Circle((fieldStartX+(fieldWidth/2), fieldStartY+(fieldHeight/2)), 0.5, color=fieldLinesColor)
        ax.add_artist(engagingPoint)
        # Penalty point 1
        penaltyPoint1 = plt.Circle((fieldStartX+(fieldWidth/9), fieldStartY+(fieldHeight/2)), 0.5, color=fieldLinesColor)
        ax.add_artist(penaltyPoint1)
        # Penalty point 2
        penaltyPoint2 = plt.Circle((fieldStartX+(fieldWidth-fieldWidth/9), fieldStartY+(fieldHeight/2)), 0.5, color=fieldLinesColor)
        ax.add_artist(penaltyPoint2)
        # Penalty area 1 arc
        penaltyArc1 = mpatches.Arc([fieldStartX+(fieldWidth*0.093), fieldStartY+(fieldHeight/2)], 22, 22, angle=270, theta1=45, theta2=135, color=fieldLinesColor)
        ax.add_patch(penaltyArc1)
        # Penalty area 2 arc
        penaltyArc2 = mpatches.Arc([fieldStartX+(fieldWidth-(fieldWidth*0.092)), fieldStartY+(fieldHeight/2)], 22, 22, angle=90, theta1=45, theta2=135, color=fieldLinesColor)
        ax.add_patch(penaltyArc2)
        # Corner arc 1
        cornerArc1 = mpatches.Arc([fieldStartX, fieldStartY], 4, 4, angle=-45, theta1=45, theta2=135, color=fieldLinesColor)
        ax.add_patch(cornerArc1)
        # Corner arc 2
        cornerArc2 = mpatches.Arc([fieldStartX, fieldStartY+fieldHeight], 4, 4, angle=225, theta1=45, theta2=135, color=fieldLinesColor)
        ax.add_patch(cornerArc2)
        # Corner arc 3
        cornerArc2 = mpatches.Arc([fieldStartX+fieldWidth, fieldStartY+fieldHeight], 4, 4, angle=-225, theta1=45, theta2=135, color=fieldLinesColor)
        ax.add_patch(cornerArc2)
        # Corner arc 4
        cornerArc2 = mpatches.Arc([fieldStartX+fieldWidth, fieldStartY], 4, 4, angle=45, theta1=45, theta2=135, color=fieldLinesColor)
        ax.add_patch(cornerArc2)

        # Points
        plt.scatter(home_datas[:, 0]+fieldStartX, home_datas[:, 1], s=home_datas[:, 2], c='yellow', alpha=0.5, zorder=2)

    """
    Shows the soccerfield.
    """
    def show(self):
        plt.plot()
        #plt.savefig('save.png')
        plt.show()


# Test
"""
home_datas = np.array([[70, 30, 80], [95, 80, 100]])
sf = Soccerfield(home_datas)
sf.show()
"""
