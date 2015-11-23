NAME = EP3
SOURCE = $(NAME).c
OUTPUT = $(NAME)

LIBDIR = ./Bibliotecas/
LIBS = Entrada Utils QR MMQ Saída Plot
LIBFILES   = $(addprefix $(LIBDIR), $(LIBS:=.c))
LIBHEADERS = $(addprefix $(LIBDIR), $(LIBS:=.h))

CC     = gcc
CFLAGS = -Wall -g
LFLAGS = -lm

.PHONY: all clean tex

$(OUTPUT): $(LIBFILES) $(LIBHEADERS) $(SOURCE)
	$(CC) $(CFLAGS) $(LIBFILES) $(SOURCE) $(LFLAGS) -o $(OUTPUT)

tex: $(NAME).tex
	pdflatex $(NAME).tex


clean:
	rm -f $(OUTPUT) Dados/*.out Dados/*.pdf
