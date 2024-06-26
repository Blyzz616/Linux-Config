#!/bin/bash

echo -e "\e[32;1mSet\e[0m"
echo -e "\t0:  \e[0mRegular\e[0m\t\t\t\\\e[0m"
echo -e "\t1:  \e[1mBold\e[0m\t\t\t\\\e[1m"
echo -e "\t2:  \e[2mDim\e[0m\t\t\t\t\\\e[2m"
echo -e "\t4:  \e[4mUnderlined\e[0m\t\t\t\\\e[4m"
echo -e "\t5:  \e[5mBlink\e[0m\t\t\t\\\e[5m"
echo -e "\t6:  Overline - breaks Blink - removed."
echo -e "\t7:  \e[7mInvert\e[0m\t\t\t\\\e[7m"
echo -e "\t8:  Hidden\t\t\t\\\e[8m"
echo -e "\t9:  \e[9mStrikeout\e[0m\t\t\t\\\e[9m"
echo
echo -e "\e[32;1mReset - Add \"2\" before \"Set\" code\e[0m"
echo -e "\t\e[0m0: Reset all\e[0m\t\t\t\\\e[0m"
#echo -e "\t\e[21m21:  Bold/bright\e[0m\t\t\t\\\e[21m - doesn't work?"
echo -e "\t\e[22m22:  Dim\e[0m\t\t\t\\\e[22m"
echo -e "\t\e[24m24:  Underlined\e[0m\t\t\t\\\e[24m"
echo -e "\t\e[25m25:  Blink\e[0m\t\t\t\\\e[25m"
echo -e "\t\e[27m27:  Reverse\e[0m\t\t\t\\\e[27m"
echo -e "\t\e[28m28:  Hidden\e[0m\t\t\t\\\e[28m"
echo -e "\t\e[29m29:  Strikeout\e[0m\t\t\t\\\e[29m"
echo
echo -e "\e[32;1mForeground (text);"
echo -e "\t\e[39m39:  Default\e[0m\t\t\t\\\e[39m"
echo -e "\t\e[30;107m30:  Black\e[0m \u2190 inverted \t\t\\\e[30m"
echo -e "\t\e[31m31:  Red\e[0m\t\t\t\\\e[31m"
echo -e "\t\e[32m32:  Green\e[0m\t\t\t\\\e[32m"
echo -e "\t\e[33m33:  Yellow\e[0m\t\t\t\\\e[33m"
echo -e "\t\e[34m34:  Blue\e[0m\t\t\t\\\e[34m"
echo -e "\t\e[35m35:  Magenta\e[0m\t\t\t\\\e[35m"
echo -e "\t\e[36m36:  Cyan\e[0m\t\t\t\\\e[36m"
echo -e "\t\e[37m37:  Light Gray\e[0m\t\t\t\\\e[37m"
echo -e "\t\e[90m90:  Dark Gray\e[0m\t\t\t\\\e[90m"
echo -e "\t\e[91m91:  Light Red\e[0m\t\t\t\\\e[91m"
echo -e "\t\e[92m92:  Light Green\e[0m\t\t\\\e[92m"
echo -e "\t\e[93m93:  Light Yellow\e[0m\t\t\\\e[93m"
echo -e "\t\e[94m94:  Light Blue\e[0m\t\t\t\\\e[94m"
echo -e "\t\e[95m95:  Light Magenta\e[0m\t\t\\\e[95m"
echo -e "\t\e[96m96:  Light Cyan\e[0m\t\t\t\\\e[96m"
echo -e "\t\e[97m97:  White\e[0m\t\t\t\\\e[97m"
echo

echo -e "\e[32;1mBackground\e[0m"
echo -e "\t\e[49m49:  Default\e[0m\t\t\t\\\e[49m"
echo -e "\t\e[40m40:  Black\e[0m\t\t\t\\\e[40m"
echo -e "\t41:  \e[41mRed\e[0m\t\t\t\\\e[41m"
echo -e "\t42:  \e[42mGreen\e[0m\t\t\t\\\e[42m"
echo -e "\t43:  \e[43mYellow\e[0m\t\t\t\\\e[43m"
echo -e "\t44:  \e[44mBlue\e[0m\t\t\t\\\e[44m"
echo -e "\t45:  \e[45mMagenta\e[0m\t\t\t\\\e[45m"
echo -e "\t46:  \e[46mCyan\e[0m\t\t\t\\\e[46m"
echo -e "\t47:  \e[30;47mLight Gray\e[0m\t\t\t\\\e[30m\t  +black text\t\\\e[30;47m"
echo -e "\t100: \e[30;100mDark Gray\e[0m\t\t\t\\\e[30m\t  +black text\t\\\e[30;100m"
echo -e "\t101: \e[30;101mLight Red\e[0m\t\t\t\\\e[30m\t  +black text\t\\\e[30;101m"
echo -e "\t102: \e[30;102mLight Green\e[0m\t\t\\\e[30m\t  +black text\t\\\e[30;102m"
echo -e "\t103: \e[30;103mLight Yellow\e[0m\t\t\\\e[30m\t  +black text\t\\\e[30;103m"
echo -e "\t104: \e[30;104mLight Blue\e[0m\t\t\t\\\e[30m\t  +black text\t\\\e[30;104m"
echo -e "\t105: \e[30;105mLight Magenta\e[0m\t\t\\\e[30m\t  +black text\t\\\e[30;105m"
echo -e "\t106: \e[30;106mLight Cyan\e[0m\t\t\t\\\e[30m\t  +black text\t\\\e[30;106m"
echo -e "\t107: \e[30;107mWhite\e[0m\t\t\t\\\e[30m\t  +black text\t\\\e[30;107m"
echo
