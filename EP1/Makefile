NAME = EP1
SOURCE = $(NAME).f95
OUTPUT = $(NAME).out

MODDIR = ./Módulos/
MODULES = matriz trisys cholesky entrada
MODFILES = $(addprefix $(MODDIR), $(MODULES:=.f95))

FFLAGS = -Wall -fdefault-real-8 # Usar double como default

.PHONY: all clean

$(OUTPUT): $(MODFILES) $(SOURCE)
	f95 $(FFLAGS) $(MODFILES) $(SOURCE) -o $(OUTPUT) && ./$(OUTPUT)

clean:
	echo $(MODFILES)
	rm $(OUTPUT)
