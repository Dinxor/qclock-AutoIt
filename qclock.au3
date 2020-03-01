#include <GUIConstants.au3>
Opt("TrayIconHide", 1)
Opt("GUIOnEventMode", 1) 
$size0 = FileGetSize ( @ScriptDir & "\qclock.ini" )
If @error Then
    MsgBox(16, "Ошибка", "Файл настроек не найден")
    Exit - 1
EndIf
Dim $Stars[5]
Dim $Mix[64][3]
$cx = 0
$cy = 0
$dynamic = 0
$font = IniRead ( "qclock.ini", "Gui", "Font", 12 )
$lang = IniRead ( "qclock.ini", "Gui", "Lang", 'eng' )
$refr = IniRead ( "qclock.ini", "Gui", "Refr", 100 )
$act = IniRead ( "qclock.ini", "Gui", "Act", 0xF0F0F0 )
$shade = IniRead ( "qclock.ini", "Gui", "Shade", 0x292929 )
$backgr = IniRead ( "qclock.ini", "Gui", "Backgr", 0x030303 )
$colored = IniRead ( "qclock.ini", "Gui", "Colored", 0 )
If $colored=1 Then
	$dynamic = IniRead ( "qclock.ini", "Gui", "Dynamic", 0 )
	$Color = IniReadSection("qclock.ini", "Color")
EndIf
$newlang = $lang
$guistate = 0
While 1
	If $newlang <> $lang AND $guistate = 1 Then
		$lang = $newlang
		GUIDelete()
		$guistate = 0
	EndIf
	If $guistate = 0 Then
;		$x = 0
		$CMin = 61
		$OldMin = 12
		$Oldtime = 0
		If $lang = 'rus' Then
			$Col = 12
			$Row = 11
			$Ekv = 20
			Dim $Symbols[12][11] = [['Ч','Е','Т','Ы','Р','Е','Ш','Е','С','Т','Ь'], _
									['О','Д','И','Н','Н','А','Д','Ц','А','Т','Ь'], _
									['К','Д','В','Е','Н','А','Д','Ц','А','Т','Ь'], _
									['Д','Е','С','Я','Т','Ь','П','Я','Т','Ь','У'], _
									['В','О','С','Е','М','Ь','Т','Р','И','А','Н'], _
									['Д','Е','В','Я','Т','Ь','Д','В','А','Ы','Ф'], _
									['С','Ш','Ч','А','С','А','Ч','А','С','О','В'], _
									['У','Г','Л','Д','В','А','Т','Р','И','Б','Ж'], _
									['Э','П','Я','Т','Н','А','Д','Ц','А','Т','Ь'], _
									['С','О','Р','О','К','Д','Е','С','Я','Т','Ь'], _
									['П','Я','Т','Ь','Д','Е','С','Я','Т','Р','У'], _
									['П','Я','Т','Ь','Щ','Л','М','И','Н','У','Т']]
			Dim $Words[24][3] = [[2,1,10],[1,0,4],[5,6,3],[4,6,3],[0,0,6],[3,6,4],[0,6,5],[4,2,4],[4,0,2],[5,0,6],[3,0,6],[1,0,11], _
								[6,2,3],[6,5,1],[6,6,5],[11,0,4],[9,5,6],[8,1,5],[7,3,3],[7,6,3],[9,0,5],[10,0,9],[8,6,5],[11,6,5]]
;							    12  001  1  002 2   004  3  008   4  010  5  020  6  040  7 080  ВО 100   9  200   10 400  11  800 
;							    ЧАС 001  -А 002 Ч-В 004  5  008  10  010  5_ 020  2_ 040  3_ 080 40 100  50  200  *10 400  МИН 800
			Dim $Cl[24] = [0x004001,0x001002,0x003004,0x003008,0x003010,0x004020,0x004040,0x004080,0x004180,0x004200,0x004400,0x004800, _
						   0x000000,0x808000,0x810000,0xC20000,0xC40000,0xC48000,0xC80000,0xC88000,0x900000,0x908000,0xA00000,0xA08000]
		Else
			$Col = 10
			$Row = 11
			$Ekv = 6
			Dim $Symbols[10][11] = [['I','T','L','I','S','A','S','T','I','M','E'], _
									['A','C','Q','U','A','R','T','E','R','O','C'], _
									['T','W','E','N','T','Y','F','I','V','E','X'], _
									['H','A','L','F','B','T','E','N','F','T','O'], _
									['P','A','S','T','E','R','U','N','I','N','E'], _
									['O','N','E','S','I','X','T','H','R','E','E'], _
									['F','O','U','R','F','I','V','E','T','W','O'], _
									['E','I','G','H','T','E','L','E','V','E','N'], _
									['S','E','V','E','N','T','W','E','L','V','E'], _
									['T','E','N','S','E','O''','C','L','O','C','K']]
			Dim $Words[24][3] = [[8,5,6],[5,0,3],[6,8,3],[5,6,5],[6,0,4],[6,4,4],[5,3,3],[8,0,5],[7,0,5],[4,7,4],[9,0,3],[7,5,6], _
								[9,5,6],[2,6,4],[3,5,3],[1,2,7],[2,0,6],[2,0,10],[3,0,4],[0,0,2],[0,3,2],[0,7,4],[4,0,4],[3,9,2]]
;								 12  001 1  002  2  004  3  008 4   010  5  020  6  040   7 080   8 100    9 200  10 400  11 800
;								 0   001  5 002  10 004  15 008 20  010  25 020  30 040  IT 080  IS 100 TIME 200 PAST 400 TO 800
			Dim $Cl[24] = [0x000001,0x000002,0x000004,0x000008,0x000010,0x000020,0x000040,0x000080,0x000100,0x000200,0x000400,0x000800, _
						   0x181000,0x582000,0x584000,0x588000,0x590000,0x592000,0x5C0000,0x992000,0x990000,0x988000,0x984000,0x982000]
		EndIf

		Dim $Id[$Col+1][$Row+1]	
		If $cx = 0 and $cy = 0 Then
			$hGui=GUICreate('qclock', 2*$font*($row+2)-$font, 2*$font*($col+2)-0.5*$font, -1, -1, BitOR( $WS_BORDER, $WS_POPUP))
		Else
			$hGui=GUICreate('qclock', 2*$font*($row+2)-$font, 2*$font*($col+2)-0.5*$font, $cx, $cy, BitOR( $WS_BORDER, $WS_POPUP))
		EndIf
		GUISetBkColor ($backgr)
		GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
		GUISetFont($font)
		$Stars[1] = GUICtrlCreateLabel ('*', $font, 0.5*$font, -1, -1, -1, $GUI_WS_EX_PARENTDRAG)
		$Stars[2] = GUICtrlCreateLabel ('*', 2*$font*($row+1)-0.5*$font, 0.5*$font)
		GUICtrlSetOnEvent($Stars[2], "CLOSEClicked")
		$Stars[3] = GUICtrlCreateLabel ('*', 2*$font*($row+1)-0.5*$font, 2*$font*($col+1))
		GUICtrlSetOnEvent($Stars[3], "MinimizeClicked")
		$Stars[4] = GUICtrlCreateLabel ('*', $font, 2*$font*($col+1))
		GUICtrlSetOnEvent($Stars[4], "Switchlang")
		If $lang = 'rus' Then
			GUICtrlSetTip ( $Stars[1], 'Переместить' )
			GUICtrlSetTip ( $Stars[2], 'Выключить' )
			GUICtrlSetTip ( $Stars[3], 'Свернуть' )
			GUICtrlSetTip ( $Stars[4], 'Переключить язык RUS/ENG' )
		Else
			GUICtrlSetTip ( $Stars[1], 'Move this clock' )
			GUICtrlSetTip ( $Stars[2], 'Turn off' )
			GUICtrlSetTip ( $Stars[3], 'Hide' )
			GUICtrlSetTip ( $Stars[4], 'Switch language RUS/ENG' )
		EndIf
		For $i = 1 to 4
			GUICtrlSetColor ( $Stars[$i], $shade )
		Next
		For $j = 0 to $Row-1
			For $i = 0 to $Col-1
				$s = $Symbols[$i][$j]
				If $s = 'I' Then
					$Id[$i][$j] = GUICtrlCreateLabel ($s, 2.3*$font + 2*$font*$j, 2*$font + 2*$font*$i)
				Else
					$Id[$i][$j] = GUICtrlCreateLabel ($s, 2*$font + 2*$font*$j, 2*$font + 2*$font*$i)
				EndIf
				GUICtrlSetColor ( $Id[$i][$j], $shade )
			Next
		Next
		GUISetState ()
		$guistate = 1
	EndIf
	If $guistate = 1 Then
		If $CMin <> @MIN Then
			$CurrMin = Floor(@MIN/5)
			If Mod(@MIN, 5) = 0 Then
				For $i = 1 to 4
					GUICtrlSetColor ( $Stars[$i], $shade )
				Next
			Else
				For $i = 1 to Mod(@MIN, 5)
					GUICtrlSetColor ( $Stars[$i], $act )
				Next
			EndIf
			$CMin = @MIN
			If $CurrMin <> $OldMin OR $dynamic = 1 Then
				If $CurrMin <> $OldMin Then
					If $CurrMin > $Ekv Then
						$CurrHr = Mod((1+@HOUR), 12)
					Else
						$CurrHr = Mod(@HOUR, 12)
					EndIf
					$Newtime = BitOR ( $Cl[$CurrMin+12], $Cl[$CurrHr] )
					$rT = BitAND ( BitXOR ( $Newtime, $Oldtime ), $Oldtime)
					$sT = BitAND ( BitXOR ( $Newtime, $Oldtime ), $Newtime)
					$Oldtime = $Newtime
					$OldMin = $CurrMin
					$aT = BitOR ( $rT, $sT )
				Else
					$aT = $Newtime
					$sT = $Newtime
					$rT = 0
				EndIf
				$x = 0
				$Mask = 0x000001
				For $j = 0 to 23
					If BitAND ( $Mask, $aT ) Then
						For $i = 0 to $Words[$j][2]-1
							$Mix[$x][0] = $Words[$j][0]
							$Mix[$x][1] = $Words[$j][1]+$i
							If BitAND ( $sT, $Mask ) Then
								$Mix[$x][2] = 1
							Else
								$Mix[$x][2] = 0
							EndIf
							$x = $x+1
						Next			
					EndIf
					$Mask = BitShift ( $Mask, -1 )
				Next
				$x = $x-1
				While $x >= 0
					$r = Random( $x )
					If $Mix[$r][2] = 0 Then
						GUICtrlSetColor ( $Id[$Mix[$r][0]][$Mix[$r][1]], $shade )
					Else
						If $colored=1 Then
							$c = Random( 1, $Color[0][0] )
							GUICtrlSetColor ( $Id[$Mix[$r][0]][$Mix[$r][1]], $Color[$c][1] )
						Else
							GUICtrlSetColor ( $Id[$Mix[$r][0]][$Mix[$r][1]], $act )
						EndIf
					EndIf
					If $x > $r Then
						$Mix[$r][0] = $Mix[$x][0]
						$Mix[$r][1] = $Mix[$x][1]
						$Mix[$r][2] = $Mix[$x][2]
					EndIf
					$x = $x - 1
					Sleep ( $refr )
				WEnd
			EndIf
		EndIf
	Sleep ( 100 )
	EndIf
Wend

Func CLOSEClicked()
	GUIDelete()
	Exit
EndFunc

Func MinimizeClicked()
	GUISetState(@SW_MINIMIZE, $hGui)
EndFunc

Func Switchlang()
	If $lang = 'rus' Then
		$newlang = 'eng'
	Else
		$newlang = 'rus'
	EndIf
	$Position = WinGetPos( "qclock" )
	$cx = $Position[0]
	$cy = $Position[1]
EndFunc
