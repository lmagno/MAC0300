NAME = EP1
PROGRAM = $(NAME).f95
OUTPUT = $(NAME).out
MODULES = cholesky.f95 entrada.f95 
FLAGS = -fdefault-real-8 # Usar double como default
.PHONY: all clean

$(OUTPUT): $(MODULES) $(PROGRAM)
	f95 $(FLAGS) $(MODULES) $(PROGRAM) -o $(OUTPUT) && ./$(OUTPUT)

clean:
	rm $(OUTPUT)
