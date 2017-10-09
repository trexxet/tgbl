#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <wchar.h>
#include <locale.h>
#include <ncurses.h>

#include "colors.h"
#include "unicode.h"

uint8_t parseKey(int key);
void redraw();
void rectangle(uint8_t y1, uint8_t x1, uint8_t y2, uint8_t x2);
void error(char *msg);
void final();

enum { F_READ, F_WRITE };
void rwFile(uint8_t write, char *name);

struct { uint8_t Y, X; } size, pos = {1, 1};
uint8_t fg = CL_BLACK, bg = CL_LGRAY;
wchar_t chr = 32;
uint8_t data[25][160] = {0};
uint8_t showTransparency = 1;

void init()
{
	// Init ncurses
	setlocale(LC_CTYPE, "");
	initscr();
	start_color();
	cbreak();
	noecho();
	curs_set(0);

	// Check window size
	int height, width;
	getmaxyx(stdscr, height, width);
	if ((height < 33) || (width < 82))
		error("Minimum terminal window size is 33x82");

	// Check for color support
	if ((COLORS < 256) || !has_colors())
		error("Your terminal doesn't support BIOS colors\n");

	// Init BIOS color pairs
	for (int i = 0; i < COLOR_NUM; i++)
		for (int j = 0; j < BGCOLOR_NUM; j++)
			init_pair(_COLORPAIR(i, j), color[i], color[j]);
}

void main(int argc, char **argv)
{
	init();

	if (argc != 2)
		error("Please specify the file, e.g. ./apet file.bin\n");
	if (access(argv[1], R_OK) != -1)
		rwFile(F_READ, argv[1]);
	else
	{
		size.Y = 25;
		size.X = 80;
	}

	int running = 1;
	while (running)
	{
		redraw();
		running = parseKey(getch());
		if (running == 2)
			rwFile(F_WRITE, argv[1]);
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
			chr < 255 ? chr++ : (chr = 32);
			break;
		case 'q': // Decrease char
			chr > 32 ? chr-- : (chr = 255);
			break;
		case ' ': // Place char
			data[pos.Y - 1][(pos.X-1)*2] = chr;
			data[pos.Y - 1][(pos.X-1)*2 + 1] = fg | (bg << 4);
			break;
		case 'd': // Delete char
			data[pos.Y - 1][(pos.X-1)*2] = 0;
			data[pos.Y - 1][(pos.X-1)*2 + 1] = 0;
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
		case 'u': // Decrease height
			if (size.Y > 1) size.Y--;
			break;
		case 'm': // Increase height
			if (size.Y < 25) size.Y++;
			break;
		case 'h': // Decrease width
			if (size.X > 1) size.X--;
			break;
		case 'k': // Increase width
			if (size.X < 80) size.X++;
			break;
		case 'b': // Toggle transparency highlight
			showTransparency ^= 1;
			break;
		case 'o': // Save
			return 2;
		case 't': // Quit
			return 0;
	}
	return 1;
}

void redraw()
{
	erase();
	// Draw header
	mvprintw(0, 0, "Y: %d X: %d Char: %d ", pos.Y, pos.X, chr);
	if (chr < 128)
		printw("(%c) ", chr);
	else
		printw("(%lc) ", unicode[chr - 128]);
	SET_PAIR(fg, bg);
	printw(" COLOR ");
	RESET_PAIR;
	printw(" Height: %d Width: %d", size.Y, size.X);

	// Draw picture
	int i = 0;
	for (; i < size.Y; i++)
		for (int j = 0; j < size.X; j++)
		{
			if ((i == pos.Y - 1) && (j == pos.X - 1))
			{  // Draw cursor
				attron(A_BLINK | A_BOLD);
				mvaddch(i + 2, j + 1, 'X');
				attroff(A_BLINK | A_BOLD);
			}
			else
				if (data[i][j*2] == 0 && showTransparency)
				{
					attron(A_BLINK);
					mvaddch(i + 2, j + 1, '-');
					attroff(A_BLINK);
				}
				else
				{  // Draw symbol
					SET_PAIR(data[i][j*2 + 1] & 0xF, data[i][j*2 + 1] >> 4);
					if (data[i][j*2] < 128)
						mvaddch(i + 2, j + 1, data[i][j*2]);
					else
						mvprintw(i + 2, j + 1, "%lc", unicode[data[i][j*2] - 128]);
					RESET_PAIR;
				}
		}

	// Draw footer & box
	rectangle(1, 0, size.Y + 2, size.X + 1);
	mvprintw(i + 3, 0, "Arrows to move; Q/W to change char; Space to place char; D to delete char\n");
	printw("A/S to change background; Z/X to change foreground\n");
	printw("B to toggle transparency highlight\n");
	printw("U/M to change height; H/K to change width\n");
	printw("O to save; T to quit");
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

void rwFile(uint8_t write, char *name)
{
	FILE *file = fopen(name, (write ? "wb" : "rb"));
	if (write)
		fwrite(&size, sizeof(size), 1, file);
	else 
		fread(&size, sizeof(size), 1, file);
	for (int i = 0; i < size.Y; i++)
		for (int j = 0; j < size.X; j++)
			if (write)
				fwrite(data[i] + j*2, 2, 1, file);
			else
				fread(data[i] + j*2, 2, 1, file);
	fclose(file);
	file = NULL;
}

void error(char *msg)
{
	erase();
	mvprintw(0, 0, msg);
	refresh();
	getch();
	final();
}

void final()
{
	endwin();
	exit(0);
}
