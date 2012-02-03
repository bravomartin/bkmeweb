import sys, re, json, csv
import datetime
import dateutil.parser as dparser
from operator import itemgetter, attrgetter
import operator

import httplib2


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
	row["ADDRESS"] += ", "+ str(row["VIOLATION_COUNTY"]).strip()  if "VIOLATION_COUNTY" in row else ""
	
	#if row["VALID"] == 1:	
	
	baseurl = "https://maps.googleapis.com/maps/api/geocode/json?sensor=false&address="
	address = urlencode(row["ADDRESS"]+ ", New York")
	h = httplib2.Http()
	resp, content = h.request(baseurl+address, "GET")
	
	
	print str(row["VALID"])+"\t"+str(row["ISSUE_DATE"])+"\t"+row["ADDRESS"]
	
