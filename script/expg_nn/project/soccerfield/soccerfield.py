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
    def __init__(self, home_shots, away_shots,
                       home_team, away_team,
                       home_np_goals, away_np_goals,
                       home_p_goals, away_p_goals,
                       home_color, away_color):
        fig, ax = plt.subplots(figsize=(12, 10))

        # Conserve scaling
        plt.axis('equal')

        # Background color
        ax.set_axis_bgcolor('green')
        fig.patch.set_facecolor('green')

        # No axes
        plt.axis('off')
        ax.set_ylim(ymin=0, ymax=100)
        plt.subplots_adjust(left=0, bottom=0, top=0.95, right=1)

        fieldLinesColor = 'white'
        fieldLinesWitdh = 1

        # Field size
        self.fieldStartX = 10
        self.fieldStartY = 10
        self.fieldWidth  = 100
        self.fieldHeight = 70

        # Field lines
        self.drawLine(ax, self.fieldStartX, self.fieldStartY, self.fieldStartX+self.fieldWidth, self.fieldStartY, fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, self.fieldStartX, self.fieldStartY+self.fieldHeight, self.fieldStartX+self.fieldWidth, self.fieldStartY+self.fieldHeight, fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, self.fieldStartX, self.fieldStartY, self.fieldStartX, self.fieldStartY+self.fieldHeight, fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, self.fieldStartX+self.fieldWidth, self.fieldStartY, self.fieldStartX+self.fieldWidth, self.fieldStartY+self.fieldHeight, fieldLinesWitdh, fieldLinesColor)
        # Penalty area 1
        self.drawLine(ax, self.fieldStartX, self.fieldStartY+(self.fieldHeight/4.77), self.fieldStartX+(self.fieldWidth*0.17), self.fieldStartY+(self.fieldHeight/4.77), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, self.fieldStartX+(self.fieldWidth*0.17), self.fieldStartY+(self.fieldHeight/4.77), self.fieldStartX+(self.fieldWidth*0.17), self.fieldStartY+(self.fieldHeight/1.26), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, self.fieldStartX+(self.fieldWidth*0.17), self.fieldStartY+(self.fieldHeight/1.26), self.fieldStartX, self.fieldStartY+(self.fieldHeight/1.26), fieldLinesWitdh, fieldLinesColor)
        # GK area 1
        self.drawLine(ax, self.fieldStartX, self.fieldStartY+(self.fieldHeight/2.71), self.fieldStartX+(self.fieldWidth*0.05), self.fieldStartY+(self.fieldHeight/2.71), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, self.fieldStartX+(self.fieldWidth*0.05), self.fieldStartY+(self.fieldHeight/2.71), self.fieldStartX+(self.fieldWidth*0.05), self.fieldStartY+(self.fieldHeight/1.58), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, self.fieldStartX+(self.fieldWidth*0.05), self.fieldStartY+(self.fieldHeight/1.58), self.fieldStartX, self.fieldStartY+(self.fieldHeight/1.58), fieldLinesWitdh, fieldLinesColor)
        # Goal 1
        self.drawLine(ax, self.fieldStartX, self.fieldStartY+(self.fieldHeight/2.27), self.fieldStartX-1, self.fieldStartY+(self.fieldHeight/2.27), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, self.fieldStartX-1, self.fieldStartY+(self.fieldHeight/2.27), self.fieldStartX-1,  self.fieldStartY+(self.fieldHeight/1.79), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, self.fieldStartX-1,  self.fieldStartY+(self.fieldHeight/1.79), self.fieldStartX, self.fieldStartY+(self.fieldHeight/1.79), fieldLinesWitdh, fieldLinesColor)
        # Midfield
        self.drawLine(ax, self.fieldStartX+(self.fieldWidth/2), self.fieldStartY, self.fieldStartX+(self.fieldWidth/2), self.fieldStartY+(self.fieldHeight), fieldLinesWitdh, fieldLinesColor)
        # Penalty area 2
        self.drawLine(ax, self.fieldStartX+self.fieldWidth, self.fieldStartY+(self.fieldHeight/4.77), self.fieldStartX+(self.fieldWidth-self.fieldWidth*0.17), self.fieldStartY+(self.fieldHeight/4.77), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, self.fieldStartX+(self.fieldWidth-self.fieldWidth*0.17), self.fieldStartY+(self.fieldHeight/4.77), self.fieldStartX+(self.fieldWidth-self.fieldWidth*0.17), self.fieldStartY+(self.fieldHeight/1.26), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, self.fieldStartX+(self.fieldWidth-self.fieldWidth*0.17), self.fieldStartY+(self.fieldHeight/1.26), self.fieldStartX+self.fieldWidth, self.fieldStartY+(self.fieldHeight/1.26), fieldLinesWitdh, fieldLinesColor)
        # GK area 2
        self.drawLine(ax, self.fieldStartX+self.fieldWidth, self.fieldStartY+(self.fieldHeight/2.71), self.fieldStartX+(self.fieldWidth-self.fieldWidth*0.05), self.fieldStartY+(self.fieldHeight/2.71), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, self.fieldStartX+(self.fieldWidth-self.fieldWidth*0.05), self.fieldStartY+(self.fieldHeight/2.71), self.fieldStartX+(self.fieldWidth-self.fieldWidth*0.05), self.fieldStartY+(self.fieldHeight/1.58), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, self.fieldStartX+(self.fieldWidth-self.fieldWidth*0.05), self.fieldStartY+(self.fieldHeight/1.58), self.fieldStartX+self.fieldWidth, self.fieldStartY+(self.fieldHeight/1.58), fieldLinesWitdh, fieldLinesColor)
        # Goal 2
        self.drawLine(ax, self.fieldStartX+self.fieldWidth, self.fieldStartY+(self.fieldHeight/2.27), self.fieldStartX+self.fieldWidth+1, self.fieldStartY+(self.fieldHeight/2.27), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, self.fieldStartX+self.fieldWidth+1, self.fieldStartY+(self.fieldHeight/2.27), self.fieldStartX+self.fieldWidth+1,  self.fieldStartY+(self.fieldHeight/1.79), fieldLinesWitdh, fieldLinesColor)
        self.drawLine(ax, self.fieldStartX+self.fieldWidth+1,  self.fieldStartY+(self.fieldHeight/1.79), self.fieldStartX+self.fieldWidth, self.fieldStartY+(self.fieldHeight/1.79), fieldLinesWitdh, fieldLinesColor)
        # Center circle
        centerCircle = plt.Circle((self.fieldStartX+(self.fieldWidth/2), self.fieldStartY+(self.fieldHeight/2)), 12, color=fieldLinesColor, fill=False)
        ax.add_artist(centerCircle)
        # Engaging point
        engagingPoint = plt.Circle((self.fieldStartX+(self.fieldWidth/2), self.fieldStartY+(self.fieldHeight/2)), 0.5, color=fieldLinesColor)
        ax.add_artist(engagingPoint)
        # Penalty point 1
        penaltyPoint1 = plt.Circle((self.fieldStartX+(self.fieldWidth/9), self.fieldStartY+(self.fieldHeight/2)), 0.5, color=fieldLinesColor)
        ax.add_artist(penaltyPoint1)
        # Penalty point 2
        penaltyPoint2 = plt.Circle((self.fieldStartX+(self.fieldWidth-self.fieldWidth/9), self.fieldStartY+(self.fieldHeight/2)), 0.5, color=fieldLinesColor)
        ax.add_artist(penaltyPoint2)
        # Penalty area 1 arc
        penaltyArc1 = mpatches.Arc([self.fieldStartX+(self.fieldWidth*0.093), self.fieldStartY+(self.fieldHeight/2)], 22, 22, angle=270, theta1=45, theta2=135, zorder=1, color=fieldLinesColor)
        ax.add_patch(penaltyArc1)
        # Penalty area 2 arc
        penaltyArc2 = mpatches.Arc([self.fieldStartX+(self.fieldWidth-(self.fieldWidth*0.092)), self.fieldStartY+(self.fieldHeight/2)], 22, 22, angle=90, theta1=45, theta2=135, zorder=1, color=fieldLinesColor)
        ax.add_patch(penaltyArc2)
        # Corner arc 1
        cornerArc1 = mpatches.Arc([self.fieldStartX, self.fieldStartY], 4, 4, angle=-45, theta1=45, theta2=135, zorder=1, color=fieldLinesColor)
        ax.add_patch(cornerArc1)
        # Corner arc 2
        cornerArc2 = mpatches.Arc([self.fieldStartX, self.fieldStartY+self.fieldHeight], 4, 4, angle=225, theta1=45, theta2=135, zorder=1, color=fieldLinesColor)
        ax.add_patch(cornerArc2)
        # Corner arc 3
        cornerArc2 = mpatches.Arc([self.fieldStartX+self.fieldWidth, self.fieldStartY+self.fieldHeight], 4, 4, angle=-225, theta1=45, theta2=135, zorder=1, color=fieldLinesColor)
        ax.add_patch(cornerArc2)
        # Corner arc 4
        cornerArc2 = mpatches.Arc([self.fieldStartX+self.fieldWidth, self.fieldStartY], 4, 4, angle=45, theta1=45, theta2=135, zorder=1, color=fieldLinesColor)
        ax.add_patch(cornerArc2)

        # Grass
        grassStep = self.fieldWidth/10
        for i in xrange(self.fieldStartX, self.fieldWidth+1, grassStep):
            grassColor = 'green'
            if((i/grassStep)%2 == 0):
                grassColor = '#32CD32'
            ax.add_patch(
                mpatches.Rectangle(
                    (i, self.fieldStartY),   # (x,y)
                    grassStep,          # width
                    self.fieldHeight,          # height
                    color=grassColor,
                    alpha=0.5,
                    zorder=0
                )
            )

        # Legend
        ax.add_patch(
            mpatches.Rectangle(
                (self.fieldStartX, self.fieldStartY+self.fieldHeight),   # (x,y)
                self.fieldWidth,          # width
                18,          # height
                color='#333333'
            )
        )

        font_size = 16
        font_small_size = 12
        # Score
        home_goals = str(home_np_goals)
        if(home_p_goals > 0):
            home_goals = home_goals + ' (+' + str(home_p_goals) + ' pen)'
        away_goals = str(away_np_goals)
        if(away_p_goals > 0):
            away_goals = away_goals + ' (+' + str(away_p_goals) + ' pen)'
        ax.text(self.fieldStartX+(self.fieldWidth/2), self.fieldStartY+self.fieldHeight+12, ' ', color='white', family='monospace', size=font_small_size, horizontalalignment='center')
        ax.text(self.fieldStartX+(self.fieldWidth/2)-7, self.fieldStartY+self.fieldHeight+12, home_team+' '+home_goals, color='white', family='monospace', size=font_size, horizontalalignment='right')
        ax.text(self.fieldStartX+(self.fieldWidth/2)+7, self.fieldStartY+self.fieldHeight+12, away_goals+' '+away_team, color='white', family='monospace', size=font_size, horizontalalignment='left')
        # Shots
        ax.text(self.fieldStartX+(self.fieldWidth/2), self.fieldStartY+self.fieldHeight+7, 'Tirs', color='white', family='monospace', size=font_small_size, horizontalalignment='center')
        ax.text(self.fieldStartX+(self.fieldWidth/2)-7, self.fieldStartY+self.fieldHeight+7, str(home_shots[:, 2].size), color='white', family='monospace', size=font_size, horizontalalignment='right')
        ax.text(self.fieldStartX+(self.fieldWidth/2)+7, self.fieldStartY+self.fieldHeight+7, str(away_shots[:, 2].size), color='white', family='monospace', size=font_size, horizontalalignment='left')
        # ExpG
        ax.text(self.fieldStartX+(self.fieldWidth/2), self.fieldStartY+self.fieldHeight+2, 'expG', color='white', family='monospace', size=font_small_size, horizontalalignment='center')
        ax.text(self.fieldStartX+(self.fieldWidth/2)-7, self.fieldStartY+self.fieldHeight+2, str(round(np.sum(home_shots[:, 3]), 2)), color='white', family='monospace', size=font_size, horizontalalignment='right')
        ax.text(self.fieldStartX+(self.fieldWidth/2)+7, self.fieldStartY+self.fieldHeight+2, str(round(np.sum(away_shots[:, 3]), 2)), color='white', family='monospace', size=font_size, horizontalalignment='left')
        # Points
        # Create two arrays: one for shots and one for goals
        home_no_goals = home_shots[home_shots[:, 2] == 0]
        home_goals    = home_shots[home_shots[:, 2] == 1]
        away_no_goals = away_shots[away_shots[:, 2] == 0]
        away_goals    = away_shots[away_shots[:, 2] == 1]
        plt.scatter(self.fieldWidth-self.scaleX(home_no_goals[:, 0])+self.fieldStartX, self.scaleY(home_no_goals[:, 1])+self.fieldStartY, s=home_no_goals[:, 3]*400, c=home_color, alpha=0.8, marker='o', zorder=2)
        plt.scatter(self.fieldWidth-self.scaleX(home_goals[:, 0])+self.fieldStartX,    self.scaleY(home_goals[:, 1])+self.fieldStartY,    s=home_goals[:, 3]*400,    c=home_color, alpha=0.8, marker='h', zorder=2)
        plt.scatter(self.scaleX(away_no_goals[:, 0])+self.fieldStartX,                 self.scaleY(away_no_goals[:, 1])+self.fieldStartY, s=away_no_goals[:, 3]*400, c=away_color, alpha=0.8, marker='o', zorder=2)
        plt.scatter(self.scaleX(away_goals[:, 0])+self.fieldStartX,                    self.scaleY(away_goals[:, 1])+self.fieldStartY,    s=away_goals[:, 3]*400,    c=away_color, alpha=0.8, marker='h', zorder=2)


    """
    Scale X point.
    """
    def scaleX(self, x):
        return (x*self.fieldWidth)/100

    """
    Scale Y point.
    """
    def scaleY(self, y):
        return (y*self.fieldHeight)/100

    """
    Shows the soccerfield.
    """
    def show(self):
        plt.plot()
        plt.show()

    """
    Saves the soccerfield
    """
    def save(self, file):
        plt.plot()
        plt.savefig(file, facecolor='green')
