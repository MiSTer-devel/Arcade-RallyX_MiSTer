---------------------------------------------------------------------------------
-- 
-- Arcade: New Rally-X  port to MiSTer by MiSTer-X
-- 18 September 2019
-- From: https://github.com/MrX-8B/MiSTer-Arcade-RallyX
-- 
---------------------------------------------------------------------------------
-- FPGA New Rally-X for Spartan-3 Starter Board
------------------------------------------------
-- Copyright (c) 2005 MiSTer-X
---------------------------------------------------------------------------------
-- T80/T80s - Version : 0242
-----------------------------
-- Z80 compatible microprocessor core
-- Copyright (c) 2001-2002 Daniel Wallner (jesus@opencores.org)
---------------------------------------------------------------------------------
-- 
-- 
-- Keyboard inputs :
--
--   F2          : Coin + Start 2 players
--   F1          : Coin + Start 1 player
--   UP,DOWN,LEFT,RIGHT arrows : Movements
--   SPACE/CTRL  : Smoke
--
-- MAME/IPAC/JPAC Style Keyboard inputs:
--   5           : Coin 1
--   6           : Coin 2
--   1           : Start 1 Player
--   2           : Start 2 Players
--   R,F,D,G     : Player 2 Movements
--   A/S         : Player 2 Smoke
--
-- Joystick support.
-- 
-- 
---------------------------------------------------------------------------------
-- 22 October 2019
---------------------------------------------------------------------------------
--  FIXED: CRT video problems
-- CHANGE: Keyboard inputs
---------------------------------------------------------------------------------

                                *** Attention ***

ROMs are not included. In order to use this arcade, you need to provide the
correct ROMs.

To simplify the process .mra files are provided in the releases folder, that
specifies the required ROMs with checksums. The ROMs .zip filename refers to the
corresponding file of the M.A.M.E. project.

Please refer to https://github.com/MiSTer-devel/Main_MiSTer/wiki/Arcade-Roms for
information on how to setup and use the environment.

Quickreference for folders and file placement:

/_Arcade/<game name>.mra
/_Arcade/cores/<game rbf>.rbf
/_Arcade/mame/<mame rom>.zip
/_Arcade/hbmame/<hbmame rom>.zip
