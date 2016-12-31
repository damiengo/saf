import sys

from transform_csv import transform_matches_series

if(len(sys.argv) < 2):
    print "Use: command <csv file path>"
    sys.exit(2)

csv_path = sys.argv[1]
print "CSV in: "+csv_path
transform_matches_series.transform_matches_series(csv_path)
