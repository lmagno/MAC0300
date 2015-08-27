NAME = EP1
PROGRAM = $(NAME).f95
OUTPUT = $(NAME).out
MODULES = matriz.f95 trisys.f95 cholesky.f95 entrada.f95 
FLAGS = -Wall -fdefault-real-8 # Usar double como default
.PHONY: all clean

$(OUTPUT): $(MODULES) $(PROGRAM)
	f95 $(FLAGS) $(MODULES) $(PROGRAM) -o $(OUTPUT) && ./$(OUTPUT)

clean:
	rm $(OUTPUT)
