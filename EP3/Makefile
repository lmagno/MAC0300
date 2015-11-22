NAME = EP3
SOURCE = $(NAME).c
OUTPUT = $(NAME).out

LIBDIR = ./Bibliotecas/
LIBS = Entrada Utils QR MMQ
LIBFILES   = $(addprefix $(LIBDIR), $(LIBS:=.c))
LIBHEADERS = $(addprefix $(LIBDIR), $(LIBS:=.h))

CC     = gcc
CFLAGS = -Wall -g
LFLAGS = -lm

.PHONY: all clean

$(OUTPUT): $(LIBFILES) $(LIBHEADERS) $(SOURCE)
	$(CC) $(CFLAGS) $(LIBFILES) $(SOURCE) $(LFLAGS) -o $(OUTPUT)

clean:
	rm -f $(OUTPUT)
