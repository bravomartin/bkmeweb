import sys, re, json, csv
import datetime
from time import strftime
import dateutil.parser as dparser
from operator import itemgetter, attrgetter
import operator
import urllib

data = list()
labels = ["VALID","ISSUE_DATE","ADDRESS","LAT","LON","ACCURACY"]

csvfile = csv.reader(sys.stdin)

j = 0
for cells in csvfile:
	i = 0
	row = dict()
	for cell in cells:
		row[labels[i]] = cell
		i+=1
	
	data.append(row)
	j+=1

#header

for row in data:
	

#	"20100301"

	if row["VALID"] == "-1":	
		#print "fixing geo"
		#http://maps.google.com/maps/geo?output=csv&key=ddd&q=159+ellery+street,+brooklyn+new+york
		baseurl = "http://maps.google.com/maps/geo?output=csv&key=ddd&q="
		address = urllib.quote_plus(row["ADDRESS"])
		g = urllib.urlopen(baseurl+address)
		coordinates = g.read().split(",")
		row["ACCURACY"] = coordinates[1]
		row["LAT"] = coordinates[2]
		row["LON"] = coordinates[3]
		row["GEO"] = coordinates[2]+","+coordinates[3]
		if int(row["ACCURACY"]) > 1: 
			row["VALID"] = 1
	
	print str(row["VALID"])+","+str(row["ISSUE_DATE"])+","+row["ADDRESS"]+","+row["LAT"]+","+row["LON"]+","+row["ACCURACY"]
	
