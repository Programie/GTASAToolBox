<?php
function KeyMap($Key)
{
	switch ($Key)
	{
		case 16:// Shift
			return Language("Shift");
		case 17:// Ctrl
			return Language("Ctrl");
		case 18:// Alt
			return "Alt";
		case 19:// Pause
			return "Pause";
		case 45:// Insert
			return Language("Insrt");
		case 46:// Delete
			return Language("Del");
		case 42:// Print
		case 44:// Snapshot
			return Language("Prnt");
		case 48:// 0
		case 49:// 1
		case 50:// 2
		case 51:// 3
		case 52:// 4
		case 53:// 5
		case 54:// 6
		case 55:// 7
		case 56:// 8
		case 57:// 9
			return chr($Key);
		case 65:// A
		case 66:// B
		case 67:// C
		case 68:// D
		case 69:// E
		case 70:// F
		case 71:// G
		case 72:// H
		case 73:// I
		case 74:// J
		case 75:// K
		case 76:// L
		case 77:// M
		case 78:// N
		case 79:// O
		case 80:// P
		case 81:// Q
		case 82:// R
		case 83:// S
		case 84:// T
		case 85:// U
		case 86:// V
		case 87:// W
		case 88:// X
		case 89:// Y
		case 90:// Z
			return chr($Key);
		case 96:// NumPad 0
		case 97:// NumPad 1
		case 98:// NumPad 2
		case 99:// NumPad 3
		case 100:// NumPad 4
		case 101:// NumPad 5
		case 102:// NumPad 6
		case 103:// NumPad 7
		case 104:// NumPad 8
		case 105:// NumPad 9
			return "NumPad ".chr($Key-48);
		case 112:// F1
			return "F1";
		case 113:// F2
			return "F2";
		case 114:// F3
			return "F3";
		case 115:// F4
			return "F4";
		case 116:// F5
			return "F5";
		case 117:// F6
			return "F6";
		case 118:// F7
			return "F7";
		case 119:// F8
			return "F8";
		case 120:// F9
			return "F9";
		case 121:// F10
			return "F10";
		case 122:// F11
			return "F11";
		case 123:// F12
			return "F12";
		case 124:// F13
			return "F13";
		case 125:// F14
			return "F14";
		case 126:// F15
			return "F15";
		case 127:// F16
			return "F16";
		case 128:// F17
			return "F17";
		case 129:// F18
			return "F18";
		case 130:// F19
			return "F19";
		case 131:// F20
			return "F20";
		case 132:// F21
			return "F21";
		case 133:// F22
			return "F22";
		case 134:// F23
			return "F23";
		case 135:// F24
			return "F24";
	}
}
?>