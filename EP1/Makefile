NAME = EP1
PROGRAM = $(NAME).f95
OUTPUT = $(NAME).out
MODULES = cholesky.f95 input.f95 

.PHONY: all clean

$(OUTPUT): $(MODULES) $(PROGRAM)
	f95 $(MODULES) $(PROGRAM) -o $(OUTPUT) && ./$(OUTPUT)

clean:
	rm $(OUTPUT)
