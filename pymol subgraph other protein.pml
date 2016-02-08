# create a new network with the selection and export table of edges to untitled.csv
cd /Users/ofer/Documents/Dropbox/Uni/Research/files/graph
python
edgeList=[]
with open("Untitled.csv") as f:
	content = f.readlines()
stline=""
for line in content:
	stline=line.split(",")[1].split("\"")[1]
	edgeList.append(stline)
del edgeList[0]

pairsInProteins=[]
with open("pairsInProteins.txt") as f:
	content = f.readlines()
stline=[]
for line in content:
	stline=line.split(" ")
	pairsInProteins.append(stline)
del pairsInProteins[0]

for i in pairsInProteins:
	i[1]=i[1][:-2]
for i in pairsInProteins:
	i[1]=i[1].split(",")

allEdgeLocations=[]
chosenEdgeLocations=[]
toHighlight=[]
with open("LocationGraph.txt") as f:
	content = f.readlines()
stline=""
for line in content:
	stline=line.split(" ")
	allEdgeLocations.append(stline)
del allEdgeLocations[0]
for i in allEdgeLocations:
	i[1]=i[1][:-2]

edgeNumber = len(edgeList)
edgesInProteins=[]
for protein in pairsInProteins:
	numberOfEdges=0.0
	proteinLine=[]
	proteinLine.append(protein[0])
	for edge in edgeList:
		foundEdge=False
		for i in protein[1]:
			if len(i)>0 and int(edge) == int(i):
				numberOfEdges=numberOfEdges+1
				foundEdge=True
			if foundEdge:
				break
				print "broken"			
	proteinLine.append(numberOfEdges/edgeNumber)
	proteinLine.append(str(int(numberOfEdges))+":"+str(int(edgeNumber)))
	edgesInProteins.append(proteinLine)

edgesInProteins=sorted(edgesInProteins, key=lambda edgeInProt: edgeInProt[1], reverse=True)



# --------to change the protein that is shown, change this number----------------

toShow=2

#----------------------------------------------------



chosenProt=edgesInProteins[toShow][0]

for edge in edgeList:
	for edgeLoc in allEdgeLocations:
		if int(edge) == int(edgeLoc[0]):
			chosenLoc=edgeLoc
			chosenLoc[1]=edgeLoc[1].split("|")
			for prots in chosenLoc[1]:
				pline=prots.split(".")
				if pline[0] == chosenProt:
					prline=pline
					del prline[0]
					toHighlight.append(prline)

python end
cmd.load("pdbs/"+chosenProt+".pdb")
set ignore_case, 0
color grey, all
for octuple in toHighlight: cmd.select("peps", "resi " +octuple[0]+"+"+octuple[1]+"+"+octuple[2]+"+"+octuple[3]+"+"+octuple[4]+"+"+octuple[5]+"+"+octuple[6]+"+"+octuple[7]), cmd.color("red", "peps"), cmd.distance("ho1", "i. "+octuple[0]+" and n. N", "i. "+octuple[1]+" and n. O", 10.0, 2), cmd.distance("ho1", "i. "+octuple[2]+" and n. N", "i. "+octuple[3]+" and n. O", 10.0, 2), cmd.distance("ho1", "i. "+octuple[4]+" and n. N", "i. "+octuple[5]+" and n. O", 10.0, 2), cmd.distance("ho1", "i. "+octuple[6]+" and n. N", "i. "+octuple[7]+" and n. O", 10.0, 2)
deselect
cmd.origin("resi " +toHighlight[0][0])
center origin
zoom center, 20
print edgesInProteins
print chosenProt
print edgesInProteins[toShow]