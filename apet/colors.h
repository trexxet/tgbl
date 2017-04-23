#define COLOR_NUM 16
#define BGCOLOR_NUM (COLOR_NUM / 2)
#define COLORPAIR_NUM 128

#define _COLORPAIR(fg, bg) (BGCOLOR_NUM * (fg) + (bg) + 1)
#define SET_PAIR(fg, bg) attrset(COLOR_PAIR(_COLORPAIR((fg), (bg))))
#define RESET_PAIR attrset(COLOR_PAIR(0));

// BIOS colors
typedef enum {
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
} BIOS_color;

// Terminal color codes matched to BIOS color codes
const static uint8_t color[16] = {0, 4, 2, 6, 1, 5, 94, 7, 8, 12, 10, 6, 9, 13, 11, 15};

