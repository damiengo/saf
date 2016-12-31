import sys

from extract_sqlite import extract_matches

if(len(sys.argv) < 3):
    print "Use: command <sqlite file path> <csv file path>"
    sys.exit(2)

db_path = sys.argv[1]
csv_path = sys.argv[2]
print "Source database: "+db_path
print "CSV dest: "+csv_path
extract_matches.extract_matches(db_path, csv_path)
