#define COLOR_NUM 16
#define BGCOLOR_NUM (COLOR_NUM / 2)
#define COLORPAIR_NUM 128

#define _COLORPAIR(fg, bg) (BGCOLOR_NUM * (fg) + (bg) + 1)
#define SET_PAIR(fg, bg) attrset(COLOR_PAIR(_COLORPAIR((fg), (bg))))
#define RESET_PAIR attrset(COLOR_PAIR(0));

// BIOS colors
enum {
	CL_BLACK,
	CL_BLUE,
	CL_GREEN,
	CL_CYAN,
	CL_RED,
	CL_MAGENTA,
	CL_BROWN,
	CL_LGRAY,
	CL_DGRAY,
	CL_LBLUE,
	CL_LGREEN,
	CL_LCYAN,
	CL_LRED,
	CL_LMAGENTA,
	CL_YELLOW,
	CL_WHITE
};

// xterm color codes matched to BIOS color codes
const static uint8_t color[16] = {0, 19, 34, 37, 124, 127, 130, 248, 240, 63, 83, 87, 203, 207, 227, 15};
