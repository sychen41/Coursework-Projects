CC= gcc

# 32-bit SPARC (yankees.acad.ece.udel.edu, stimpy.acad.ece.udel.edu)
ASN1_LIB = -lasn1c
# x86-64 (mlb.acad.ece.udel.edu, hoek.eecis.udel.edu)
#ASN1_LIB = -lasn1c64
# 32-bit x86 (orioles.acad.ece.udel.edu, ren.eecis.udel.edu)
#ASN1_LIB = -lasn1c86

# Set to directory with ASN1 libraries
ASN1_LIBDIR = -L../asn1libs

# Set up libraries
LIBS= $(ASN1_LIBDIR) $(ASN1_LIB)
# Solaris libs
LIBS += -lm -lsocket -lnsl

# Includes
CFLAGS=-I/usr/local/asn1c/share/asn1c/

# Program Specific Info
ASN1_FILE = MyTest.asn1
EXECUTABLE1 = asn1client
EXECUTABLE2 = asn1server
OBJECTS1 = $(EXECUTABLE1).o
OBJECTS2 = $(EXECUTABLE2).o

all: compile-asn1 $(EXECUTABLE2)
exe: $(EXECUTABLE2)

# Compile ASN1 into library
compile-asn1: $(ASN1_FILE)
	mkdir -p asn1
	cd asn1; \
	asn1c -fnative-types -R ../$(ASN1_FILE)
	cd asn1; \
	find . -name '*.c' -exec $(CC) $(CFLAGS) $(INCLUDES) -c \{\} \;
	cd asn1; \
	ar rcs asn1.a *.o; 
	cd asn1; \
	rm *.o

# Compile Programs
$(EXECUTABLE1): $(OBJECTS1)
	$(CC) $(CFLAGS) -o $@ $(OBJECTS1) asn1/asn1.a $(LIBS)
	rm *.o

$(EXECUTABLE2): $(OBJECTS2)
	$(CC) $(CFLAGS) -o $@ $(OBJECTS2) asn1/asn1.a $(LIBS)
	rm *.o

# Build object files
.c.o: 
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

# Clean
clean: clean-asn1 clean-c

# Remove all ASN1 generated files
clean-asn1:
	-rm -R -f asn1

# Remove all C generated files
clean-c:
	-rm -f $(EXECUTABLE1) $(EXECUTABLE2)
