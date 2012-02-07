import sys, re, json, csv
import datetime
import dateutil.parser as dparser
from operator import itemgetter, attrgetter
import operator
import urllib

data = list()
labels = ["SUMMONS_NUMBER","PLATE","STATE","WS_TYPE","ISSUE_DATE","VIOLATION_DESCRIPTION","VIOLATION_CODE","FINE_AMOUNT","VIOLATION_COUNTY","FRONT_OF_OPPOSITE","HOUSE_NUMBER","STREET_NAME","INTERSECT_STREET_NAME","STREET_CODE1","STREET_CODE2","STREET_CODE3"]
boroughs = {"BX" : "Bronx", "K" : "Kings", "NY" : "Manhattan", "Q" : "Queens", "R" : "Richmond"}


csvfile = csv.reader(sys.stdin)

#get rid of the titles row

#get every row and split them into cells
j = 0
for cells in csvfile:
	i = 0
	row = dict()
	for cell in cells:
		row[labels[i]] = cell
		i+=1
	row["VALID"] = 1	
	if j > 0:
		data.append(row)
	j+=1

#header
print "VALID"+","+"ISSUE_DATE"+","+"ADDRESS"+","+"LAT"+","+"LON"+","+"ACCURACY"


for row in data:
	row["VIOLATION_COUNTY"] = row["VIOLATION_COUNTY"].strip()
	

#	"20100301"
	try:
		row['ISSUE_DATE'] = datetime.datetime.strptime(row['ISSUE_DATE'], "%Y%m%d")
	except ValueError:
		row["VALID"] = 0
	if row["VIOLATION_COUNTY"] in boroughs:
		row["VIOLATION_COUNTY"] = boroughs[row["VIOLATION_COUNTY"]]
	else:
		row["VALID"] = 0
		
	row["ADDRESS"] = ""
	row["ADDRESS"] += str(row["HOUSE_NUMBER"]).strip() if "HOUSE_NUMBER" in row else ""
	row["ADDRESS"] += " "+ str(row["STREET_NAME"]).strip()  if "STREET_NAME" in row else ""
	row["ADDRESS"] += " "+ str(row["INTERSECT_STREET_NAME"]).strip()  if "INTERSECT_STREET_NAME" in row else ""
	row["ADDRESS"] += " "+ str(row["VIOLATION_COUNTY"]).strip()  if "VIOLATION_COUNTY" in row else ""
	
	#if row["VALID"] == 1:	
	#http://maps.google.com/maps/geo?output=csv&key=ddd&q=159+ellery+street,+brooklyn+new+york
	baseurl = "http://maps.google.com/maps/geo?output=csv&key=ddd&q="
	address = urllib.quote_plus(row["ADDRESS"]+ ", New York")
	g = urllib.urlopen(baseurl+address)
	coordinates = g.read().split(",")
	if int(coordinates[1]) < 1:
		row["VALID"] = -1
	row["ACCURACY"] = coordinates[1]
	row["LAT"] = coordinates[2]
	row["LON"] = coordinates[3]
	row["GEO"] = coordinates[2]+","+coordinates[3]
	row['ISSUE_DATE'] = row['ISSUE_DATE'].strftime("%Y-%m-%d %H:%M:%S")
	
	print str(row["VALID"])+","+str(row["ISSUE_DATE"])+","+row["ADDRESS"]+","+row["LAT"]+","+row["LON"]+","+row["ACCURACY"]
	
