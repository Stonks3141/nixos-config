// somebar - dwl bar
// See LICENSE file for copyright and license details.

#pragma once
#include "common.hpp"

constexpr bool topbar = true;

constexpr int paddingX = 10;
constexpr int paddingY = 2;

// See https://docs.gtk.org/Pango/type_func.FontDescription.from_string.html
constexpr const char* font = "FiraCode Nerd Font 12";

constexpr ColorScheme colorInactive = {Color(0xca, 0xd3, 0xf5), Color(0x24, 0x27, 0x3a)};
constexpr ColorScheme colorActive = {Color(0x24, 0x27, 0x3a), Color(0xc6, 0xa0, 0xf6)};
constexpr const char* termcmd[] = {"foot", nullptr};

static std::vector<std::string> tagNames = {
	"1", "2", "3",
	"4", "5", "6",
	"7", "8", "9",
};

constexpr Button buttons[] = {
	{ ClkStatusText,   BTN_RIGHT,  spawn,      {.v = termcmd} },
};
