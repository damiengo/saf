import sys

from graph_data import entropies

if(len(sys.argv) < 2):
    print "Use: command <csv file path>"
    sys.exit(2)

csv_path = sys.argv[1]

print "Graph data"

e = entropies.Entropies(csv_path)
e.mean_by_league()
