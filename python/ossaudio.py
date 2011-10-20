import ossaudiodev as osv

dev = osv.open("r")

print dev.getfmts()
