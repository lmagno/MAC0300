NAME = EP3
SOURCE = $(NAME).c
OUTPUT = $(NAME).out

LIBDIR = ./Bibliotecas/
LIBS = 
LIBFILES   = $(addprefix $(LIBDIR), $(LIBS:=.c))
LIBHEADERS = $(addprefix $(LIBDIR), $(LIBS:=.h))
CC     = gcc
CFLAGS = -Wall

.PHONY: all clean

$(OUTPUT): $(LIBFILES) $(SOURCE)
	$(CC) $(CFLAGS) $(LIBFILES) $(SOURCE) -o $(OUTPUT)

clean:
	rm -f $(OUTPUT)
