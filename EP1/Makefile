NAME = EP1
SOURCE = $(NAME).f95
OUTPUT = $(NAME).out

MODDIR = ./Módulos/
MODULES = utils entrada trisys cholesky sol_chol lu sol_lu
MODFILES = $(addprefix $(MODDIR), $(MODULES:=.f95))

FFLAGS = -Wall -fdefault-real-8 # Usar double como default

.PHONY: all clean

$(OUTPUT): $(MODFILES) $(SOURCE)
	gfortran $(FFLAGS) $(MODFILES) $(SOURCE) -o $(OUTPUT)

clean:
	rm -f $(OUTPUT) *.mod
