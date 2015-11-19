NAME = EP3
SOURCE = $(NAME).c
OUTPUT = $(NAME).out

LIBDIR = ./Bibliotecas/
LIBS = Entrada Utils
LIBFILES   = $(addprefix $(LIBDIR), $(LIBS:=.c))
LIBHEADERS = $(addprefix $(LIBDIR), $(LIBS:=.h))
CC     = gcc
CFLAGS = -Wall -g

.PHONY: all clean

$(OUTPUT): $(LIBFILES) $(LIBHEADERS) $(SOURCE)
	$(CC) $(CFLAGS) $(LIBFILES) $(SOURCE) -o $(OUTPUT)

clean:
	rm -f $(OUTPUT)
