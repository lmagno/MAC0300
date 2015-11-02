NAME = EP2
SOURCE = $(NAME).f95
OUTPUT = $(NAME).out

MODDIR = ./Módulos/
MODULES = class_SparseMatrixCSC class_SparseMatrixCOO RandomSparseMatrix CG
MODFILES = $(addprefix $(MODDIR), $(MODULES:=.f95))
MODFILES += ../EP1/Módulos/cholesky.f95 ../EP1/Módulos/trisys.f95 # Usar módulos do EP1
FFLAGS = -Wall -fdefault-real-8 -g3 -Wimplicit-interface # Usar double como default

.PHONY: all clean

$(OUTPUT): $(MODFILES) $(SOURCE)
	gfortran $(FFLAGS) $(MODFILES) $(SOURCE) -o $(OUTPUT)

clean:
	rm -f $(OUTPUT) *.mod
