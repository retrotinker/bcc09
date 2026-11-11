/* directdef.c - defines dvar, but not __direct: the declaration in
   directuse.c says it is, so ld09 must refuse to link the two */
int dvar = 3;
