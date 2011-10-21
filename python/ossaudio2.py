import ossaudiodev as osd

dev = osd.open("r")
print dev
dev.close()
