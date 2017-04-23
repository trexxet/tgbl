#include <stdlib.h>
#include <stdint.h>
#include <ctype.h>
#include <unistd.h>
#include <ncurses.h>

#include "colors.h"

uint8_t parseKey(int key);
void redraw();
void rectangle(uint8_t y1, uint8_t x1, uint8_t y2, uint8_t x2);
void loadFile(char *name);
void saveFile(char *name);
void error(char *msg);
void final();

struct { uint8_t Y, X; } size, pos;
uint8_t chr, fg, bg;
uint8_t data[80][50] = {0};

void init()
{
	// Init ncurses
	initscr();
	start_color();
	cbreak();
	noecho();
	curs_set(0);

	// Check for color support
	if ((COLORS < 256) || !has_colors())
		error("Your terminal doesn't support BIOS colors\n");

	// Init BIOS color pairs
	for (int i = 0; i < COLOR_NUM; i++)
		for (int j = 0; j < BGCOLOR_NUM; j++)
			init_pair(_COLORPAIR(i, j), color[i], color[j]);

	// Init global variables
	pos.Y = pos.X = 1;
	chr = 1;
	fg = CL_BLACK;
	bg = CL_LGRAY;
}

void main(int argc, char **argv)
{
	init();

	if (argc != 2)
		error("Please specify the file, e.g. ./apet file.bin\n");
	if (access(argv[1], R_OK) != -1)
		loadFile(argv[1]);

	int running = 1;
	size.X = size.Y = 20;
	while (running)
	{
		redraw();
		running = parseKey(getch());
		if (running == 2)
			saveFile(argv[1]);
	}

	final();
}

uint8_t parseKey(int key)
{
	switch (key)
	{
		case 65: // Key Up - move cursor up
			pos.Y > 1 ? pos.Y-- : (pos.Y = size.Y);
			break;
		case 66: // Key Down - move cursor down
			pos.Y < size.Y ? pos.Y++ : (pos.Y = 1);
			break;
		case 67: // Key Right - move cursor right
			pos.X < size.X ? pos.X++ : (pos.X = 1);
			break;
		case 68: // Key Left - move cursor left
			pos.X > 1 ? pos.X-- : (pos.X = size.X);
			break;
		case 'w': // Increase char
			chr++;
			break;
		case 'q': // Decrease char
			chr--;
			break;
		case ' ': // Place char
			data[pos.Y - 1][(pos.X-1)*2] = chr;
			data[pos.Y - 1][(pos.X-1)*2 + 1] = fg | (bg << 4);
			break;
		case 'a': // Decrease background color
			bg > 0 ? bg-- : (bg = BGCOLOR_NUM - 1);
			break;
		case 's': // Increase background color
			bg < BGCOLOR_NUM - 1 ? bg++ : (bg = 0);
			break;
		case 'z': // Decrease foreground color
			fg > 0 ? fg-- : (fg = COLOR_NUM - 1);
			break;
		case 'x': // Increase foreground color
			fg < COLOR_NUM - 1 ? fg++ : (fg = 0);
			break;
		case 'o': // Save
			return 2;
			break;
		case 'u': // Quit
			return 0;
			break;
	}
	return 1;
}

void redraw()
{
	erase();
	// Draw header
	mvprintw(0, 0, "Y: %d X: %d Char: %d", pos.Y, pos.X, chr);
	if (isprint(chr) && (chr < 128))
		printw(" (%c)", chr);
	SET_PAIR(fg, bg);
	printw(" COLOR ");
	RESET_PAIR;

	// Draw picture
	int i = 0;
	for (i; i < size.Y; i++)
		for (int j = 0; j < size.X; j++)
		{
			if ((i == pos.Y - 1) && (j == pos.X - 1))
				mvaddch(i + 2, j + 1, 'X');
			else
			{
				SET_PAIR(data[i][j*2 + 1] >> 4, data[i][j*2 + 1] & 0xF);
				mvaddch(i + 2, j + 1, data[i][j*2]);
				RESET_PAIR;
			}
		}

	// Draw footer & box
	rectangle(1, 0, size.Y + 2, size.X + 1);
	mvprintw(i + 3, 0, "Arrows to move; Q/W to change char; Space to place char\n");
	printw("A/S to change background; Z/X to change foreground\n");
	printw("O to save; U to quit");
	refresh();
}

void rectangle(uint8_t y1, uint8_t x1, uint8_t y2, uint8_t x2)
{
	mvhline(y1, x1, 0, x2-x1);
	mvhline(y2, x1, 0, x2-x1);
	mvvline(y1, x1, 0, y2-y1);
	mvvline(y1, x2, 0, y2-y1);
	mvaddch(y1, x1, ACS_ULCORNER);
	mvaddch(y2, x1, ACS_LLCORNER);
	mvaddch(y1, x2, ACS_URCORNER);
	mvaddch(y2, x2, ACS_LRCORNER);
}

void loadFile(char *name)
{
	FILE *file = fopen(name, "rb");
	fread(&size, sizeof(size), 1, file);
	for (int i = 0; i < size.Y; i++)
		for (int j = 0; j < size.X; j++)
			fread(data[i] + j*2, 2, 1, file);
	fclose(file);
	file = NULL;
}

void saveFile(char *name)
{
	FILE *file = fopen(name, "wb");
	fwrite(&size, sizeof(size), 1, file);
	for (int i = 0; i < size.Y; i++)
		for (int j = 0; j < size.X; j++)
			fwrite(data[i] + j*2, 2, 1, file);
	fclose(file);
	file = NULL;
}

void error(char *msg)
{
	printw(msg);
	refresh();
	getch();
	final();
}

void final()
{
	endwin();
	exit(0);
}
