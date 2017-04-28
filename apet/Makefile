CC = gcc
SRC = main.c
TARGET = apet

CFLAGS = --std=gnu11
LDLIBS = -lncursesw

all:
	$(CC) $(SRC) -o $(TARGET) $(CFLAGS) $(LDLIBS)

clean:
	rm -f ./*.bin
	rm -f ./$(TARGET)
