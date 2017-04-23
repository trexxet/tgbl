CC = gcc
SRC = main.c
TARGET = apet

CFLAGS = -g -O0 --std=gnu11
LDLIBS = -lncursesw

all:
	$(CC) $(SRC) -o $(TARGET) $(CFLAGS) $(LDLIBS)

run: all
	./$(TARGET) test.bin

clean:
	rm -f ./*.bin
	rm -f ./$(TARGET)
