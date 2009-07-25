# line 1 "src/ragel/parser.rl"
# Copyright (c) 2008 chiisaitsu <chiisaitsu@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# ---
#
# This is Eleanor's parser.  Its job is to define the private Screenplay#parse_!
# method, which takes the name of a plain text screenplay file.
#
# This implementation uses Ragel[http://research.cs.queensu.ca/~thurston/ragel/],
# a state machine compiler.  Run it through Ragel with:
#
#   ragel -R -o lib/eleanor/parser.rb src/ragel/parser.rl

=begin
# This is commented out so rdoc doesn't barf.  Ragel doesn't mind.


# line 37 "lib/eleanor/parser.rb"
class << self
	attr_accessor :_parser_actions
	private :_parser_actions, :_parser_actions=
end
self._parser_actions = [
	0, 1, 0, 1, 1, 1, 2, 1, 
	4, 1, 5, 1, 6, 1, 7, 1, 
	12, 1, 13, 1, 14, 1, 15, 1, 
	20, 1, 21, 1, 22, 1, 23, 2, 
	0, 8, 2, 0, 16, 2, 1, 9, 
	2, 1, 17, 2, 3, 7, 2, 6, 
	18, 2, 7, 19, 2, 14, 0, 2, 
	14, 10, 2, 15, 1, 2, 15, 11, 
	2, 20, 18, 2, 21, 19, 3, 0, 
	16, 8, 3, 1, 17, 9, 3, 3, 
	7, 19, 3, 5, 13, 7, 3, 14, 
	0, 10, 3, 14, 0, 16, 3, 15, 
	1, 11, 3, 15, 1, 17, 4, 1, 
	17, 7, 19, 4, 5, 13, 7, 19, 
	4, 14, 0, 16, 10, 4, 15, 1, 
	17, 11, 4, 21, 19, 15, 11, 5, 
	1, 17, 7, 19, 9, 5, 15, 5, 
	13, 7, 11, 6, 15, 1, 17, 7, 
	19, 11
]

class << self
	attr_accessor :_parser_key_offsets
	private :_parser_key_offsets, :_parser_key_offsets=
end
self._parser_key_offsets = [
	0, 0, 4, 8, 11, 15, 19, 27, 
	35, 39, 43, 50, 54, 58, 63, 64, 
	66, 69, 76, 78, 83, 84, 85, 86, 
	87, 95, 102, 106, 110, 111, 112, 116, 
	117, 122, 123, 128, 133, 138, 143, 148, 
	152, 156, 161, 166, 167, 172, 176, 180, 
	188, 198, 204, 208, 209, 210, 219, 229, 
	238, 244, 248, 249, 250, 251, 252, 253, 
	254, 259, 264, 269, 274, 279, 284, 289, 
	294, 299, 304, 309, 314, 319, 324, 333, 
	339, 343, 344, 345, 355, 365, 375, 385, 
	395, 405, 414, 418, 422, 423, 424, 430, 
	434, 435, 436, 446, 456, 466, 476, 486, 
	496, 506, 516, 526, 536, 546, 556, 566, 
	576, 577, 578, 587, 594, 600, 604, 611, 
	612, 613, 614, 615, 623, 627, 631, 637, 
	645, 646, 655, 656, 663, 669, 673, 679, 
	680, 681, 682, 690, 698, 708, 716
]

class << self
	attr_accessor :_parser_trans_keys
	private :_parser_trans_keys, :_parser_trans_keys=
end
self._parser_trans_keys = [
	10, 13, 11, 12, 9, 10, 13, 32, 
	32, 9, 13, 10, 13, 11, 12, 9, 
	10, 13, 32, 9, 10, 13, 32, 11, 
	12, 65, 90, 9, 10, 13, 32, 11, 
	12, 65, 90, 10, 13, 11, 12, 9, 
	10, 13, 32, 9, 10, 13, 32, 40, 
	11, 12, 10, 13, 11, 12, 9, 10, 
	13, 32, 9, 10, 13, 32, 40, 10, 
	10, 13, 41, 10, 13, 9, 10, 13, 
	32, 41, 11, 12, 9, 32, 9, 32, 
	40, 10, 13, 10, 10, 10, 10, 9, 
	10, 13, 32, 11, 12, 65, 90, 9, 
	10, 13, 32, 40, 11, 12, 10, 13, 
	11, 12, 9, 10, 13, 32, 10, 10, 
	9, 10, 13, 32, 10, 10, 13, 79, 
	11, 12, 10, 10, 13, 78, 11, 12, 
	10, 13, 84, 11, 12, 10, 13, 65, 
	11, 12, 10, 13, 71, 11, 12, 10, 
	13, 69, 11, 12, 10, 13, 11, 12, 
	9, 10, 13, 32, 32, 9, 13, 65, 
	90, 10, 13, 41, 11, 12, 10, 10, 
	13, 32, 11, 12, 10, 13, 11, 12, 
	9, 10, 13, 32, 9, 10, 13, 32, 
	11, 12, 65, 90, 9, 10, 13, 41, 
	11, 12, 32, 96, 123, 126, 9, 10, 
	13, 32, 11, 12, 9, 10, 13, 32, 
	10, 10, 9, 10, 13, 11, 12, 32, 
	96, 123, 126, 9, 10, 13, 32, 11, 
	12, 33, 96, 123, 126, 9, 10, 13, 
	11, 12, 32, 96, 123, 126, 9, 10, 
	13, 32, 11, 12, 9, 10, 13, 32, 
	10, 10, 10, 10, 10, 10, 10, 13, 
	69, 11, 12, 10, 13, 82, 11, 12, 
	10, 13, 73, 11, 12, 10, 13, 69, 
	11, 12, 10, 13, 83, 11, 12, 10, 
	13, 32, 11, 12, 10, 13, 79, 11, 
	12, 10, 13, 70, 11, 12, 10, 13, 
	32, 11, 12, 10, 13, 83, 11, 12, 
	10, 13, 72, 11, 12, 10, 13, 79, 
	11, 12, 10, 13, 84, 11, 12, 10, 
	13, 83, 11, 12, 9, 10, 13, 11, 
	12, 32, 96, 123, 126, 9, 10, 13, 
	32, 11, 12, 9, 10, 13, 32, 10, 
	10, 9, 10, 13, 79, 11, 12, 32, 
	96, 123, 126, 9, 10, 13, 78, 11, 
	12, 32, 96, 123, 126, 9, 10, 13, 
	84, 11, 12, 32, 96, 123, 126, 9, 
	10, 13, 65, 11, 12, 32, 96, 123, 
	126, 9, 10, 13, 71, 11, 12, 32, 
	96, 123, 126, 9, 10, 13, 69, 11, 
	12, 32, 96, 123, 126, 9, 10, 13, 
	11, 12, 32, 96, 123, 126, 10, 13, 
	11, 12, 9, 10, 13, 32, 10, 10, 
	9, 10, 13, 32, 11, 12, 9, 10, 
	13, 32, 10, 10, 9, 10, 13, 69, 
	11, 12, 32, 96, 123, 126, 9, 10, 
	13, 82, 11, 12, 32, 96, 123, 126, 
	9, 10, 13, 73, 11, 12, 32, 96, 
	123, 126, 9, 10, 13, 69, 11, 12, 
	32, 96, 123, 126, 9, 10, 13, 83, 
	11, 12, 32, 96, 123, 126, 9, 10, 
	13, 32, 11, 12, 33, 96, 123, 126, 
	9, 10, 13, 79, 11, 12, 32, 96, 
	123, 126, 9, 10, 13, 70, 11, 12, 
	32, 96, 123, 126, 9, 10, 13, 32, 
	11, 12, 33, 96, 123, 126, 9, 10, 
	13, 83, 11, 12, 32, 96, 123, 126, 
	9, 10, 13, 72, 11, 12, 32, 96, 
	123, 126, 9, 10, 13, 79, 11, 12, 
	32, 96, 123, 126, 9, 10, 13, 84, 
	11, 12, 32, 96, 123, 126, 9, 10, 
	13, 83, 11, 12, 32, 96, 123, 126, 
	10, 10, 10, 13, 32, 46, 58, 11, 
	12, 65, 90, 10, 13, 32, 11, 12, 
	65, 90, 9, 10, 13, 32, 11, 12, 
	9, 10, 13, 32, 9, 10, 13, 32, 
	40, 11, 12, 10, 10, 10, 10, 9, 
	10, 13, 32, 11, 12, 65, 90, 10, 
	13, 11, 12, 9, 10, 13, 32, 9, 
	10, 13, 32, 11, 12, 9, 10, 13, 
	32, 11, 12, 65, 90, 10, 10, 13, 
	32, 46, 58, 11, 12, 65, 90, 10, 
	10, 13, 32, 11, 12, 65, 90, 9, 
	10, 13, 32, 11, 12, 9, 10, 13, 
	32, 9, 10, 13, 32, 11, 12, 10, 
	10, 10, 9, 10, 13, 32, 77, 83, 
	11, 12, 9, 10, 13, 32, 77, 83, 
	11, 12, 9, 10, 13, 32, 77, 83, 
	11, 12, 65, 90, 9, 10, 13, 32, 
	77, 83, 11, 12, 9, 10, 13, 32, 
	77, 83, 11, 12, 0
]

class << self
	attr_accessor :_parser_single_lengths
	private :_parser_single_lengths, :_parser_single_lengths=
end
self._parser_single_lengths = [
	0, 2, 4, 1, 2, 4, 4, 4, 
	2, 4, 5, 2, 4, 5, 1, 0, 
	1, 5, 2, 3, 1, 1, 1, 1, 
	4, 5, 2, 4, 1, 1, 4, 1, 
	3, 1, 3, 3, 3, 3, 3, 2, 
	4, 1, 3, 1, 3, 2, 4, 4, 
	4, 4, 4, 1, 1, 3, 4, 3, 
	4, 4, 1, 1, 1, 1, 1, 1, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 4, 
	4, 1, 1, 4, 4, 4, 4, 4, 
	4, 3, 2, 4, 1, 1, 4, 4, 
	1, 1, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	1, 1, 5, 3, 4, 4, 5, 1, 
	1, 1, 1, 4, 2, 4, 4, 4, 
	1, 5, 1, 3, 4, 4, 4, 1, 
	1, 1, 6, 6, 6, 6, 6
]

class << self
	attr_accessor :_parser_range_lengths
	private :_parser_range_lengths, :_parser_range_lengths=
end
self._parser_range_lengths = [
	0, 1, 0, 1, 1, 0, 2, 2, 
	1, 0, 1, 1, 0, 0, 0, 1, 
	1, 1, 0, 1, 0, 0, 0, 0, 
	2, 1, 1, 0, 0, 0, 0, 0, 
	1, 0, 1, 1, 1, 1, 1, 1, 
	0, 2, 1, 0, 1, 1, 0, 2, 
	3, 1, 0, 0, 0, 3, 3, 3, 
	1, 0, 0, 0, 0, 0, 0, 0, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 3, 1, 
	0, 0, 0, 3, 3, 3, 3, 3, 
	3, 3, 1, 0, 0, 0, 1, 0, 
	0, 0, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	0, 0, 2, 2, 1, 0, 1, 0, 
	0, 0, 0, 2, 1, 0, 1, 2, 
	0, 2, 0, 2, 1, 0, 1, 0, 
	0, 0, 1, 1, 2, 1, 1
]

class << self
	attr_accessor :_parser_index_offsets
	private :_parser_index_offsets, :_parser_index_offsets=
end
self._parser_index_offsets = [
	0, 0, 4, 9, 12, 16, 21, 28, 
	35, 39, 44, 51, 55, 60, 66, 68, 
	70, 73, 80, 83, 88, 90, 92, 94, 
	96, 103, 110, 114, 119, 121, 123, 128, 
	130, 135, 137, 142, 147, 152, 157, 162, 
	166, 171, 175, 180, 182, 187, 191, 196, 
	203, 211, 217, 222, 224, 226, 233, 241, 
	248, 254, 259, 261, 263, 265, 267, 269, 
	271, 276, 281, 286, 291, 296, 301, 306, 
	311, 316, 321, 326, 331, 336, 341, 348, 
	354, 359, 361, 363, 371, 379, 387, 395, 
	403, 411, 418, 422, 427, 429, 431, 437, 
	442, 444, 446, 454, 462, 470, 478, 486, 
	494, 502, 510, 518, 526, 534, 542, 550, 
	558, 560, 562, 570, 576, 582, 587, 594, 
	596, 598, 600, 602, 609, 613, 618, 624, 
	631, 633, 641, 643, 649, 655, 660, 666, 
	668, 670, 672, 680, 688, 697, 705
]

class << self
	attr_accessor :_parser_indicies
	private :_parser_indicies, :_parser_indicies=
end
self._parser_indicies = [
	1, 3, 2, 0, 1, 4, 5, 1, 
	2, 7, 7, 6, 8, 9, 7, 6, 
	8, 10, 11, 8, 7, 12, 13, 15, 
	12, 14, 16, 6, 18, 13, 15, 18, 
	19, 20, 17, 21, 23, 22, 17, 25, 
	26, 27, 25, 24, 25, 26, 27, 25, 
	29, 24, 28, 30, 32, 31, 28, 34, 
	35, 36, 34, 33, 34, 35, 36, 34, 
	29, 33, 35, 37, 33, 38, 39, 33, 
	38, 39, 40, 41, 39, 39, 33, 38, 
	42, 42, 31, 42, 42, 31, 31, 28, 
	40, 33, 30, 31, 26, 43, 21, 22, 
	18, 44, 46, 18, 45, 20, 17, 47, 
	48, 49, 47, 29, 24, 28, 51, 53, 
	52, 50, 51, 54, 55, 51, 52, 54, 
	52, 51, 52, 56, 13, 15, 56, 37, 
	13, 37, 1, 3, 58, 57, 0, 1, 
	2, 1, 3, 59, 57, 0, 1, 3, 
	60, 57, 0, 1, 3, 61, 57, 0, 
	1, 3, 62, 57, 0, 1, 3, 63, 
	57, 0, 64, 65, 57, 63, 64, 66, 
	67, 64, 57, 68, 68, 69, 6, 8, 
	9, 70, 68, 6, 8, 7, 8, 9, 
	71, 68, 6, 72, 73, 68, 71, 72, 
	74, 75, 72, 68, 12, 13, 15, 12, 
	76, 77, 6, 78, 79, 81, 82, 80, 
	16, 16, 6, 78, 79, 81, 78, 83, 
	6, 79, 84, 85, 79, 83, 84, 83, 
	79, 83, 78, 79, 81, 83, 16, 16, 
	6, 78, 79, 81, 86, 80, 16, 16, 
	6, 87, 88, 89, 80, 86, 86, 71, 
	87, 88, 89, 87, 80, 71, 88, 90, 
	91, 88, 80, 90, 80, 88, 80, 74, 
	68, 72, 68, 66, 57, 64, 57, 1, 
	3, 92, 57, 0, 1, 3, 93, 57, 
	0, 1, 3, 94, 57, 0, 1, 3, 
	95, 57, 0, 1, 3, 96, 57, 0, 
	1, 3, 97, 57, 0, 1, 3, 98, 
	57, 0, 1, 3, 99, 57, 0, 1, 
	3, 100, 57, 0, 1, 3, 101, 57, 
	0, 1, 3, 102, 57, 0, 1, 3, 
	103, 57, 0, 1, 3, 104, 57, 0, 
	1, 3, 63, 57, 0, 105, 106, 108, 
	107, 109, 109, 50, 105, 106, 108, 105, 
	107, 50, 106, 110, 111, 106, 107, 110, 
	107, 106, 107, 105, 106, 108, 113, 112, 
	109, 109, 50, 105, 106, 108, 114, 112, 
	109, 109, 50, 105, 106, 108, 115, 112, 
	109, 109, 50, 105, 106, 108, 116, 112, 
	109, 109, 50, 105, 106, 108, 117, 112, 
	109, 109, 50, 105, 106, 108, 118, 112, 
	109, 109, 50, 120, 121, 122, 112, 118, 
	118, 119, 123, 125, 124, 119, 123, 126, 
	127, 123, 124, 126, 124, 123, 124, 120, 
	121, 122, 120, 112, 119, 121, 128, 129, 
	121, 112, 128, 112, 121, 112, 105, 106, 
	108, 130, 112, 109, 109, 50, 105, 106, 
	108, 131, 112, 109, 109, 50, 105, 106, 
	108, 132, 112, 109, 109, 50, 105, 106, 
	108, 133, 112, 109, 109, 50, 105, 106, 
	108, 134, 112, 109, 109, 50, 105, 106, 
	108, 135, 112, 109, 109, 50, 105, 106, 
	108, 136, 112, 109, 109, 50, 105, 106, 
	108, 137, 112, 109, 109, 50, 105, 106, 
	108, 138, 112, 109, 109, 50, 105, 106, 
	108, 139, 112, 109, 109, 50, 105, 106, 
	108, 140, 112, 109, 109, 50, 105, 106, 
	108, 141, 112, 109, 109, 50, 105, 106, 
	108, 142, 112, 109, 109, 50, 105, 106, 
	108, 118, 112, 109, 109, 50, 48, 43, 
	44, 22, 21, 23, 143, 144, 144, 45, 
	20, 17, 21, 23, 143, 45, 20, 17, 
	144, 145, 146, 144, 45, 17, 148, 149, 
	150, 148, 147, 148, 149, 150, 148, 29, 
	147, 28, 149, 19, 145, 45, 10, 7, 
	4, 2, 152, 153, 155, 152, 154, 156, 
	151, 157, 159, 158, 151, 160, 161, 162, 
	160, 158, 160, 161, 162, 160, 158, 151, 
	163, 161, 162, 163, 154, 156, 151, 161, 
	158, 157, 159, 164, 165, 165, 154, 156, 
	151, 157, 158, 157, 159, 164, 154, 156, 
	151, 165, 166, 167, 165, 154, 151, 168, 
	169, 170, 168, 154, 168, 169, 170, 168, 
	154, 151, 169, 154, 166, 154, 153, 37, 
	152, 153, 155, 152, 172, 173, 171, 0, 
	47, 48, 49, 47, 172, 173, 174, 0, 
	12, 13, 15, 12, 176, 177, 175, 109, 
	50, 56, 13, 15, 56, 172, 173, 57, 
	0, 163, 161, 162, 163, 172, 173, 171, 
	0, 0
]

class << self
	attr_accessor :_parser_trans_targs_wi
	private :_parser_trans_targs_wi, :_parser_trans_targs_wi=
end
self._parser_trans_targs_wi = [
	1, 2, 0, 33, 3, 122, 4, 0, 
	5, 43, 6, 121, 7, 141, 0, 31, 
	53, 8, 24, 0, 114, 9, 0, 23, 
	0, 10, 6, 22, 11, 15, 12, 0, 
	21, 0, 13, 6, 14, 0, 16, 17, 
	18, 20, 19, 0, 139, 0, 113, 25, 
	140, 112, 26, 27, 0, 29, 6, 28, 
	30, 0, 34, 35, 36, 37, 38, 39, 
	40, 63, 41, 62, 0, 42, 44, 45, 
	46, 61, 47, 60, 0, 48, 49, 50, 
	0, 52, 54, 0, 6, 51, 55, 56, 
	57, 59, 47, 58, 65, 66, 67, 68, 
	69, 70, 71, 72, 73, 74, 75, 76, 
	77, 79, 80, 0, 82, 78, 6, 81, 
	0, 84, 85, 86, 87, 88, 89, 90, 
	94, 95, 97, 91, 0, 93, 47, 92, 
	47, 96, 99, 100, 101, 102, 103, 104, 
	105, 106, 107, 108, 109, 110, 111, 115, 
	116, 117, 120, 0, 118, 6, 119, 124, 
	123, 138, 0, 137, 129, 125, 0, 130, 
	126, 142, 128, 127, 131, 132, 133, 136, 
	134, 142, 135, 0, 32, 64, 0, 0, 
	83, 98
]

class << self
	attr_accessor :_parser_trans_actions_wi
	private :_parser_trans_actions_wi, :_parser_trans_actions_wi=
end
self._parser_trans_actions_wi = [
	0, 0, 21, 0, 19, 0, 0, 3, 
	0, 0, 1, 0, 27, 0, 102, 0, 
	0, 0, 0, 49, 0, 5, 43, 0, 
	82, 0, 11, 0, 0, 0, 7, 9, 
	0, 17, 0, 29, 0, 0, 0, 0, 
	15, 0, 0, 13, 5, 78, 0, 0, 
	11, 0, 0, 0, 58, 0, 52, 0, 
	0, 61, 0, 0, 0, 0, 0, 0, 
	0, 0, 55, 0, 37, 0, 0, 0, 
	0, 0, 31, 0, 127, 0, 0, 0, 
	74, 0, 0, 40, 34, 0, 0, 0, 
	0, 0, 70, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 98, 0, 0, 90, 0, 
	117, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 94, 0, 86, 0, 
	112, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 5, 0, 107, 0, 46, 0, 0, 
	0, 0, 67, 0, 0, 0, 25, 0, 
	0, 23, 0, 0, 0, 0, 0, 0, 
	0, 64, 0, 122, 0, 0, 133, 139, 
	0, 0
]

class << self
	attr_accessor :_parser_eof_actions
	private :_parser_eof_actions, :_parser_eof_actions=
end
self._parser_eof_actions = [
	0, 21, 21, 3, 3, 3, 102, 49, 
	43, 82, 82, 9, 17, 17, 0, 17, 
	17, 17, 9, 9, 17, 9, 13, 43, 
	78, 82, 58, 58, 58, 58, 0, 0, 
	61, 21, 61, 61, 61, 61, 61, 61, 
	61, 37, 37, 3, 37, 37, 37, 127, 
	74, 40, 40, 40, 40, 40, 74, 74, 
	74, 74, 74, 74, 37, 37, 61, 61, 
	61, 61, 61, 61, 61, 61, 61, 61, 
	61, 61, 61, 61, 61, 61, 98, 98, 
	98, 98, 98, 117, 117, 117, 117, 117, 
	117, 117, 94, 94, 94, 94, 117, 117, 
	117, 117, 117, 117, 117, 117, 117, 117, 
	117, 117, 117, 117, 117, 117, 117, 117, 
	13, 43, 78, 78, 78, 107, 107, 49, 
	78, 3, 21, 67, 25, 25, 25, 67, 
	25, 67, 25, 67, 67, 67, 67, 67, 
	67, 0, 0, 0, 0, 0, 0
]

class << self
	attr_accessor :parser_start
end
self.parser_start = 138;
class << self
	attr_accessor :parser_first_final
end
self.parser_first_final = 138;
class << self
	attr_accessor :parser_error
end
self.parser_error = 0;

class << self
	attr_accessor :parser_en_main
end
self.parser_en_main = 138;

# line 104 "src/ragel/parser.rl"

=end

module Eleanor

  class Screenplay

    def parse_! filename
      lines= []
      last_char_cue= nil
      classes= nil
      # these are needed by ragel
      data= ''
      eof= nil
      
# line 478 "lib/eleanor/parser.rb"
class << self
	attr_accessor :_parser_actions
	private :_parser_actions, :_parser_actions=
end
self._parser_actions = [
	0, 1, 0, 1, 1, 1, 2, 1, 
	4, 1, 5, 1, 6, 1, 7, 1, 
	12, 1, 13, 1, 14, 1, 15, 1, 
	20, 1, 21, 1, 22, 1, 23, 2, 
	0, 8, 2, 0, 16, 2, 1, 9, 
	2, 1, 17, 2, 3, 7, 2, 6, 
	18, 2, 7, 19, 2, 14, 0, 2, 
	14, 10, 2, 15, 1, 2, 15, 11, 
	2, 20, 18, 2, 21, 19, 3, 0, 
	16, 8, 3, 1, 17, 9, 3, 3, 
	7, 19, 3, 5, 13, 7, 3, 14, 
	0, 10, 3, 14, 0, 16, 3, 15, 
	1, 11, 3, 15, 1, 17, 4, 1, 
	17, 7, 19, 4, 5, 13, 7, 19, 
	4, 14, 0, 16, 10, 4, 15, 1, 
	17, 11, 4, 21, 19, 15, 11, 5, 
	1, 17, 7, 19, 9, 5, 15, 5, 
	13, 7, 11, 6, 15, 1, 17, 7, 
	19, 11
]

class << self
	attr_accessor :_parser_key_offsets
	private :_parser_key_offsets, :_parser_key_offsets=
end
self._parser_key_offsets = [
	0, 0, 4, 8, 11, 15, 19, 27, 
	35, 39, 43, 50, 54, 58, 63, 64, 
	66, 69, 76, 78, 83, 84, 85, 86, 
	87, 95, 102, 106, 110, 111, 112, 116, 
	117, 122, 123, 128, 133, 138, 143, 148, 
	152, 156, 161, 166, 167, 172, 176, 180, 
	188, 198, 204, 208, 209, 210, 219, 229, 
	238, 244, 248, 249, 250, 251, 252, 253, 
	254, 259, 264, 269, 274, 279, 284, 289, 
	294, 299, 304, 309, 314, 319, 324, 333, 
	339, 343, 344, 345, 355, 365, 375, 385, 
	395, 405, 414, 418, 422, 423, 424, 430, 
	434, 435, 436, 446, 456, 466, 476, 486, 
	496, 506, 516, 526, 536, 546, 556, 566, 
	576, 577, 578, 587, 594, 600, 604, 611, 
	612, 613, 614, 615, 623, 627, 631, 637, 
	645, 646, 655, 656, 663, 669, 673, 679, 
	680, 681, 682, 690, 698, 708, 716
]

class << self
	attr_accessor :_parser_trans_keys
	private :_parser_trans_keys, :_parser_trans_keys=
end
self._parser_trans_keys = [
	10, 13, 11, 12, 9, 10, 13, 32, 
	32, 9, 13, 10, 13, 11, 12, 9, 
	10, 13, 32, 9, 10, 13, 32, 11, 
	12, 65, 90, 9, 10, 13, 32, 11, 
	12, 65, 90, 10, 13, 11, 12, 9, 
	10, 13, 32, 9, 10, 13, 32, 40, 
	11, 12, 10, 13, 11, 12, 9, 10, 
	13, 32, 9, 10, 13, 32, 40, 10, 
	10, 13, 41, 10, 13, 9, 10, 13, 
	32, 41, 11, 12, 9, 32, 9, 32, 
	40, 10, 13, 10, 10, 10, 10, 9, 
	10, 13, 32, 11, 12, 65, 90, 9, 
	10, 13, 32, 40, 11, 12, 10, 13, 
	11, 12, 9, 10, 13, 32, 10, 10, 
	9, 10, 13, 32, 10, 10, 13, 79, 
	11, 12, 10, 10, 13, 78, 11, 12, 
	10, 13, 84, 11, 12, 10, 13, 65, 
	11, 12, 10, 13, 71, 11, 12, 10, 
	13, 69, 11, 12, 10, 13, 11, 12, 
	9, 10, 13, 32, 32, 9, 13, 65, 
	90, 10, 13, 41, 11, 12, 10, 10, 
	13, 32, 11, 12, 10, 13, 11, 12, 
	9, 10, 13, 32, 9, 10, 13, 32, 
	11, 12, 65, 90, 9, 10, 13, 41, 
	11, 12, 32, 96, 123, 126, 9, 10, 
	13, 32, 11, 12, 9, 10, 13, 32, 
	10, 10, 9, 10, 13, 11, 12, 32, 
	96, 123, 126, 9, 10, 13, 32, 11, 
	12, 33, 96, 123, 126, 9, 10, 13, 
	11, 12, 32, 96, 123, 126, 9, 10, 
	13, 32, 11, 12, 9, 10, 13, 32, 
	10, 10, 10, 10, 10, 10, 10, 13, 
	69, 11, 12, 10, 13, 82, 11, 12, 
	10, 13, 73, 11, 12, 10, 13, 69, 
	11, 12, 10, 13, 83, 11, 12, 10, 
	13, 32, 11, 12, 10, 13, 79, 11, 
	12, 10, 13, 70, 11, 12, 10, 13, 
	32, 11, 12, 10, 13, 83, 11, 12, 
	10, 13, 72, 11, 12, 10, 13, 79, 
	11, 12, 10, 13, 84, 11, 12, 10, 
	13, 83, 11, 12, 9, 10, 13, 11, 
	12, 32, 96, 123, 126, 9, 10, 13, 
	32, 11, 12, 9, 10, 13, 32, 10, 
	10, 9, 10, 13, 79, 11, 12, 32, 
	96, 123, 126, 9, 10, 13, 78, 11, 
	12, 32, 96, 123, 126, 9, 10, 13, 
	84, 11, 12, 32, 96, 123, 126, 9, 
	10, 13, 65, 11, 12, 32, 96, 123, 
	126, 9, 10, 13, 71, 11, 12, 32, 
	96, 123, 126, 9, 10, 13, 69, 11, 
	12, 32, 96, 123, 126, 9, 10, 13, 
	11, 12, 32, 96, 123, 126, 10, 13, 
	11, 12, 9, 10, 13, 32, 10, 10, 
	9, 10, 13, 32, 11, 12, 9, 10, 
	13, 32, 10, 10, 9, 10, 13, 69, 
	11, 12, 32, 96, 123, 126, 9, 10, 
	13, 82, 11, 12, 32, 96, 123, 126, 
	9, 10, 13, 73, 11, 12, 32, 96, 
	123, 126, 9, 10, 13, 69, 11, 12, 
	32, 96, 123, 126, 9, 10, 13, 83, 
	11, 12, 32, 96, 123, 126, 9, 10, 
	13, 32, 11, 12, 33, 96, 123, 126, 
	9, 10, 13, 79, 11, 12, 32, 96, 
	123, 126, 9, 10, 13, 70, 11, 12, 
	32, 96, 123, 126, 9, 10, 13, 32, 
	11, 12, 33, 96, 123, 126, 9, 10, 
	13, 83, 11, 12, 32, 96, 123, 126, 
	9, 10, 13, 72, 11, 12, 32, 96, 
	123, 126, 9, 10, 13, 79, 11, 12, 
	32, 96, 123, 126, 9, 10, 13, 84, 
	11, 12, 32, 96, 123, 126, 9, 10, 
	13, 83, 11, 12, 32, 96, 123, 126, 
	10, 10, 10, 13, 32, 46, 58, 11, 
	12, 65, 90, 10, 13, 32, 11, 12, 
	65, 90, 9, 10, 13, 32, 11, 12, 
	9, 10, 13, 32, 9, 10, 13, 32, 
	40, 11, 12, 10, 10, 10, 10, 9, 
	10, 13, 32, 11, 12, 65, 90, 10, 
	13, 11, 12, 9, 10, 13, 32, 9, 
	10, 13, 32, 11, 12, 9, 10, 13, 
	32, 11, 12, 65, 90, 10, 10, 13, 
	32, 46, 58, 11, 12, 65, 90, 10, 
	10, 13, 32, 11, 12, 65, 90, 9, 
	10, 13, 32, 11, 12, 9, 10, 13, 
	32, 9, 10, 13, 32, 11, 12, 10, 
	10, 10, 9, 10, 13, 32, 77, 83, 
	11, 12, 9, 10, 13, 32, 77, 83, 
	11, 12, 9, 10, 13, 32, 77, 83, 
	11, 12, 65, 90, 9, 10, 13, 32, 
	77, 83, 11, 12, 9, 10, 13, 32, 
	77, 83, 11, 12, 0
]

class << self
	attr_accessor :_parser_single_lengths
	private :_parser_single_lengths, :_parser_single_lengths=
end
self._parser_single_lengths = [
	0, 2, 4, 1, 2, 4, 4, 4, 
	2, 4, 5, 2, 4, 5, 1, 0, 
	1, 5, 2, 3, 1, 1, 1, 1, 
	4, 5, 2, 4, 1, 1, 4, 1, 
	3, 1, 3, 3, 3, 3, 3, 2, 
	4, 1, 3, 1, 3, 2, 4, 4, 
	4, 4, 4, 1, 1, 3, 4, 3, 
	4, 4, 1, 1, 1, 1, 1, 1, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 4, 
	4, 1, 1, 4, 4, 4, 4, 4, 
	4, 3, 2, 4, 1, 1, 4, 4, 
	1, 1, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	1, 1, 5, 3, 4, 4, 5, 1, 
	1, 1, 1, 4, 2, 4, 4, 4, 
	1, 5, 1, 3, 4, 4, 4, 1, 
	1, 1, 6, 6, 6, 6, 6
]

class << self
	attr_accessor :_parser_range_lengths
	private :_parser_range_lengths, :_parser_range_lengths=
end
self._parser_range_lengths = [
	0, 1, 0, 1, 1, 0, 2, 2, 
	1, 0, 1, 1, 0, 0, 0, 1, 
	1, 1, 0, 1, 0, 0, 0, 0, 
	2, 1, 1, 0, 0, 0, 0, 0, 
	1, 0, 1, 1, 1, 1, 1, 1, 
	0, 2, 1, 0, 1, 1, 0, 2, 
	3, 1, 0, 0, 0, 3, 3, 3, 
	1, 0, 0, 0, 0, 0, 0, 0, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 3, 1, 
	0, 0, 0, 3, 3, 3, 3, 3, 
	3, 3, 1, 0, 0, 0, 1, 0, 
	0, 0, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	0, 0, 2, 2, 1, 0, 1, 0, 
	0, 0, 0, 2, 1, 0, 1, 2, 
	0, 2, 0, 2, 1, 0, 1, 0, 
	0, 0, 1, 1, 2, 1, 1
]

class << self
	attr_accessor :_parser_index_offsets
	private :_parser_index_offsets, :_parser_index_offsets=
end
self._parser_index_offsets = [
	0, 0, 4, 9, 12, 16, 21, 28, 
	35, 39, 44, 51, 55, 60, 66, 68, 
	70, 73, 80, 83, 88, 90, 92, 94, 
	96, 103, 110, 114, 119, 121, 123, 128, 
	130, 135, 137, 142, 147, 152, 157, 162, 
	166, 171, 175, 180, 182, 187, 191, 196, 
	203, 211, 217, 222, 224, 226, 233, 241, 
	248, 254, 259, 261, 263, 265, 267, 269, 
	271, 276, 281, 286, 291, 296, 301, 306, 
	311, 316, 321, 326, 331, 336, 341, 348, 
	354, 359, 361, 363, 371, 379, 387, 395, 
	403, 411, 418, 422, 427, 429, 431, 437, 
	442, 444, 446, 454, 462, 470, 478, 486, 
	494, 502, 510, 518, 526, 534, 542, 550, 
	558, 560, 562, 570, 576, 582, 587, 594, 
	596, 598, 600, 602, 609, 613, 618, 624, 
	631, 633, 641, 643, 649, 655, 660, 666, 
	668, 670, 672, 680, 688, 697, 705
]

class << self
	attr_accessor :_parser_indicies
	private :_parser_indicies, :_parser_indicies=
end
self._parser_indicies = [
	1, 3, 2, 0, 1, 4, 5, 1, 
	2, 7, 7, 6, 8, 9, 7, 6, 
	8, 10, 11, 8, 7, 12, 13, 15, 
	12, 14, 16, 6, 18, 13, 15, 18, 
	19, 20, 17, 21, 23, 22, 17, 25, 
	26, 27, 25, 24, 25, 26, 27, 25, 
	29, 24, 28, 30, 32, 31, 28, 34, 
	35, 36, 34, 33, 34, 35, 36, 34, 
	29, 33, 35, 37, 33, 38, 39, 33, 
	38, 39, 40, 41, 39, 39, 33, 38, 
	42, 42, 31, 42, 42, 31, 31, 28, 
	40, 33, 30, 31, 26, 43, 21, 22, 
	18, 44, 46, 18, 45, 20, 17, 47, 
	48, 49, 47, 29, 24, 28, 51, 53, 
	52, 50, 51, 54, 55, 51, 52, 54, 
	52, 51, 52, 56, 13, 15, 56, 37, 
	13, 37, 1, 3, 58, 57, 0, 1, 
	2, 1, 3, 59, 57, 0, 1, 3, 
	60, 57, 0, 1, 3, 61, 57, 0, 
	1, 3, 62, 57, 0, 1, 3, 63, 
	57, 0, 64, 65, 57, 63, 64, 66, 
	67, 64, 57, 68, 68, 69, 6, 8, 
	9, 70, 68, 6, 8, 7, 8, 9, 
	71, 68, 6, 72, 73, 68, 71, 72, 
	74, 75, 72, 68, 12, 13, 15, 12, 
	76, 77, 6, 78, 79, 81, 82, 80, 
	16, 16, 6, 78, 79, 81, 78, 83, 
	6, 79, 84, 85, 79, 83, 84, 83, 
	79, 83, 78, 79, 81, 83, 16, 16, 
	6, 78, 79, 81, 86, 80, 16, 16, 
	6, 87, 88, 89, 80, 86, 86, 71, 
	87, 88, 89, 87, 80, 71, 88, 90, 
	91, 88, 80, 90, 80, 88, 80, 74, 
	68, 72, 68, 66, 57, 64, 57, 1, 
	3, 92, 57, 0, 1, 3, 93, 57, 
	0, 1, 3, 94, 57, 0, 1, 3, 
	95, 57, 0, 1, 3, 96, 57, 0, 
	1, 3, 97, 57, 0, 1, 3, 98, 
	57, 0, 1, 3, 99, 57, 0, 1, 
	3, 100, 57, 0, 1, 3, 101, 57, 
	0, 1, 3, 102, 57, 0, 1, 3, 
	103, 57, 0, 1, 3, 104, 57, 0, 
	1, 3, 63, 57, 0, 105, 106, 108, 
	107, 109, 109, 50, 105, 106, 108, 105, 
	107, 50, 106, 110, 111, 106, 107, 110, 
	107, 106, 107, 105, 106, 108, 113, 112, 
	109, 109, 50, 105, 106, 108, 114, 112, 
	109, 109, 50, 105, 106, 108, 115, 112, 
	109, 109, 50, 105, 106, 108, 116, 112, 
	109, 109, 50, 105, 106, 108, 117, 112, 
	109, 109, 50, 105, 106, 108, 118, 112, 
	109, 109, 50, 120, 121, 122, 112, 118, 
	118, 119, 123, 125, 124, 119, 123, 126, 
	127, 123, 124, 126, 124, 123, 124, 120, 
	121, 122, 120, 112, 119, 121, 128, 129, 
	121, 112, 128, 112, 121, 112, 105, 106, 
	108, 130, 112, 109, 109, 50, 105, 106, 
	108, 131, 112, 109, 109, 50, 105, 106, 
	108, 132, 112, 109, 109, 50, 105, 106, 
	108, 133, 112, 109, 109, 50, 105, 106, 
	108, 134, 112, 109, 109, 50, 105, 106, 
	108, 135, 112, 109, 109, 50, 105, 106, 
	108, 136, 112, 109, 109, 50, 105, 106, 
	108, 137, 112, 109, 109, 50, 105, 106, 
	108, 138, 112, 109, 109, 50, 105, 106, 
	108, 139, 112, 109, 109, 50, 105, 106, 
	108, 140, 112, 109, 109, 50, 105, 106, 
	108, 141, 112, 109, 109, 50, 105, 106, 
	108, 142, 112, 109, 109, 50, 105, 106, 
	108, 118, 112, 109, 109, 50, 48, 43, 
	44, 22, 21, 23, 143, 144, 144, 45, 
	20, 17, 21, 23, 143, 45, 20, 17, 
	144, 145, 146, 144, 45, 17, 148, 149, 
	150, 148, 147, 148, 149, 150, 148, 29, 
	147, 28, 149, 19, 145, 45, 10, 7, 
	4, 2, 152, 153, 155, 152, 154, 156, 
	151, 157, 159, 158, 151, 160, 161, 162, 
	160, 158, 160, 161, 162, 160, 158, 151, 
	163, 161, 162, 163, 154, 156, 151, 161, 
	158, 157, 159, 164, 165, 165, 154, 156, 
	151, 157, 158, 157, 159, 164, 154, 156, 
	151, 165, 166, 167, 165, 154, 151, 168, 
	169, 170, 168, 154, 168, 169, 170, 168, 
	154, 151, 169, 154, 166, 154, 153, 37, 
	152, 153, 155, 152, 172, 173, 171, 0, 
	47, 48, 49, 47, 172, 173, 174, 0, 
	12, 13, 15, 12, 176, 177, 175, 109, 
	50, 56, 13, 15, 56, 172, 173, 57, 
	0, 163, 161, 162, 163, 172, 173, 171, 
	0, 0
]

class << self
	attr_accessor :_parser_trans_targs_wi
	private :_parser_trans_targs_wi, :_parser_trans_targs_wi=
end
self._parser_trans_targs_wi = [
	1, 2, 0, 33, 3, 122, 4, 0, 
	5, 43, 6, 121, 7, 141, 0, 31, 
	53, 8, 24, 0, 114, 9, 0, 23, 
	0, 10, 6, 22, 11, 15, 12, 0, 
	21, 0, 13, 6, 14, 0, 16, 17, 
	18, 20, 19, 0, 139, 0, 113, 25, 
	140, 112, 26, 27, 0, 29, 6, 28, 
	30, 0, 34, 35, 36, 37, 38, 39, 
	40, 63, 41, 62, 0, 42, 44, 45, 
	46, 61, 47, 60, 0, 48, 49, 50, 
	0, 52, 54, 0, 6, 51, 55, 56, 
	57, 59, 47, 58, 65, 66, 67, 68, 
	69, 70, 71, 72, 73, 74, 75, 76, 
	77, 79, 80, 0, 82, 78, 6, 81, 
	0, 84, 85, 86, 87, 88, 89, 90, 
	94, 95, 97, 91, 0, 93, 47, 92, 
	47, 96, 99, 100, 101, 102, 103, 104, 
	105, 106, 107, 108, 109, 110, 111, 115, 
	116, 117, 120, 0, 118, 6, 119, 124, 
	123, 138, 0, 137, 129, 125, 0, 130, 
	126, 142, 128, 127, 131, 132, 133, 136, 
	134, 142, 135, 0, 32, 64, 0, 0, 
	83, 98
]

class << self
	attr_accessor :_parser_trans_actions_wi
	private :_parser_trans_actions_wi, :_parser_trans_actions_wi=
end
self._parser_trans_actions_wi = [
	0, 0, 21, 0, 19, 0, 0, 3, 
	0, 0, 1, 0, 27, 0, 102, 0, 
	0, 0, 0, 49, 0, 5, 43, 0, 
	82, 0, 11, 0, 0, 0, 7, 9, 
	0, 17, 0, 29, 0, 0, 0, 0, 
	15, 0, 0, 13, 5, 78, 0, 0, 
	11, 0, 0, 0, 58, 0, 52, 0, 
	0, 61, 0, 0, 0, 0, 0, 0, 
	0, 0, 55, 0, 37, 0, 0, 0, 
	0, 0, 31, 0, 127, 0, 0, 0, 
	74, 0, 0, 40, 34, 0, 0, 0, 
	0, 0, 70, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 98, 0, 0, 90, 0, 
	117, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 94, 0, 86, 0, 
	112, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 5, 0, 107, 0, 46, 0, 0, 
	0, 0, 67, 0, 0, 0, 25, 0, 
	0, 23, 0, 0, 0, 0, 0, 0, 
	0, 64, 0, 122, 0, 0, 133, 139, 
	0, 0
]

class << self
	attr_accessor :_parser_eof_actions
	private :_parser_eof_actions, :_parser_eof_actions=
end
self._parser_eof_actions = [
	0, 21, 21, 3, 3, 3, 102, 49, 
	43, 82, 82, 9, 17, 17, 0, 17, 
	17, 17, 9, 9, 17, 9, 13, 43, 
	78, 82, 58, 58, 58, 58, 0, 0, 
	61, 21, 61, 61, 61, 61, 61, 61, 
	61, 37, 37, 3, 37, 37, 37, 127, 
	74, 40, 40, 40, 40, 40, 74, 74, 
	74, 74, 74, 74, 37, 37, 61, 61, 
	61, 61, 61, 61, 61, 61, 61, 61, 
	61, 61, 61, 61, 61, 61, 98, 98, 
	98, 98, 98, 117, 117, 117, 117, 117, 
	117, 117, 94, 94, 94, 94, 117, 117, 
	117, 117, 117, 117, 117, 117, 117, 117, 
	117, 117, 117, 117, 117, 117, 117, 117, 
	13, 43, 78, 78, 78, 107, 107, 49, 
	78, 3, 21, 67, 25, 25, 25, 67, 
	25, 67, 25, 67, 67, 67, 67, 67, 
	67, 0, 0, 0, 0, 0, 0
]

class << self
	attr_accessor :parser_start
end
self.parser_start = 138;
class << self
	attr_accessor :parser_first_final
end
self.parser_first_final = 138;
class << self
	attr_accessor :parser_error
end
self.parser_error = 0;

class << self
	attr_accessor :parser_en_main
end
self.parser_en_main = 138;

# line 119 "src/ragel/parser.rl"
      
# line 905 "lib/eleanor/parser.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = parser_start
end
# line 120 "src/ragel/parser.rl"
      File.open(filename, 'r') do |file|
        file.each_line do |line|
          line << "\n" * 3 if file.eof?
          error= lambda do |expected|
            warn "#{filename}:#{file.lineno}: parse error: expected #{expected}:"
            warn "  #{@paras[-2]}" if @paras.length >= 2
            warn "  #{@paras[-1]}" if @paras.length >= 1
            warn "  #{line.inspect}"
          end
          consume= false
          # these are needed by ragel
          data= line
          p= 0
          pe= data.length
          
# line 927 "lib/eleanor/parser.rb"
begin
	_klen, _trans, _keys, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	_trigger_goto = false
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	_keys = _parser_key_offsets[cs]
	_trans = _parser_index_offsets[cs]
	_klen = _parser_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p] < _parser_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p] > _parser_trans_keys[_mid]
	           _lower = _mid + 1
	        else
	           _trans += (_mid - _keys)
	           _break_match = true
	           break
	        end
	     end # loop
	     break if _break_match
	     _keys += _klen
	     _trans += _klen
	  end
	  _klen = _parser_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p] < _parser_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p] > _parser_trans_keys[_mid+1]
	          _lower = _mid + 2
	        else
	          _trans += ((_mid - _keys) >> 1)
	          _break_match = true
	          break
	        end
	     end # loop
	     break if _break_match
	     _trans += _klen
	  end
	end while false
	_trans = _parser_indicies[_trans]
	cs = _parser_trans_targs_wi[_trans]
	if _parser_trans_actions_wi[_trans] != 0
		_acts = _parser_trans_actions_wi[_trans]
		_nacts = _parser_actions[_acts]
		_acts += 1
		while _nacts > 0
			_nacts -= 1
			_acts += 1
			case _parser_actions[_acts - 1]
when 0 then
# line 45 "src/ragel/parser.rl"
		begin
 classes= [Action]; consume= true 		end
# line 45 "src/ragel/parser.rl"
when 1 then
# line 46 "src/ragel/parser.rl"
		begin
 error.call('Action') 		end
# line 46 "src/ragel/parser.rl"
when 2 then
# line 49 "src/ragel/parser.rl"
		begin
 classes << CharacterCue 		end
# line 49 "src/ragel/parser.rl"
when 3 then
# line 50 "src/ragel/parser.rl"
		begin
 error.call('Action') 		end
# line 50 "src/ragel/parser.rl"
when 4 then
# line 53 "src/ragel/parser.rl"
		begin
 classes << Dialog 		end
# line 53 "src/ragel/parser.rl"
when 5 then
# line 54 "src/ragel/parser.rl"
		begin
 error.call('Dialog') 		end
# line 54 "src/ragel/parser.rl"
when 6 then
# line 57 "src/ragel/parser.rl"
		begin
 classes= [Insert]; consume= true 		end
# line 57 "src/ragel/parser.rl"
when 7 then
# line 58 "src/ragel/parser.rl"
		begin
 error.call('Insert') 		end
# line 58 "src/ragel/parser.rl"
when 8 then
# line 61 "src/ragel/parser.rl"
		begin
 classes= [MontageItem]; consume= true 		end
# line 61 "src/ragel/parser.rl"
when 9 then
# line 62 "src/ragel/parser.rl"
		begin
 error.call('MontageItem') 		end
# line 62 "src/ragel/parser.rl"
when 10 then
# line 65 "src/ragel/parser.rl"
		begin
 classes= [MontageHeading]; consume= true 		end
# line 65 "src/ragel/parser.rl"
when 11 then
# line 66 "src/ragel/parser.rl"
		begin
 error.call('MontageHeading') 		end
# line 66 "src/ragel/parser.rl"
when 12 then
# line 69 "src/ragel/parser.rl"
		begin
 classes << Parenthetical 		end
# line 69 "src/ragel/parser.rl"
when 13 then
# line 70 "src/ragel/parser.rl"
		begin
 error.call('Parenthetical') 		end
# line 70 "src/ragel/parser.rl"
when 14 then
# line 73 "src/ragel/parser.rl"
		begin
 classes= [SceneHeading]; consume= true 		end
# line 73 "src/ragel/parser.rl"
when 15 then
# line 74 "src/ragel/parser.rl"
		begin
 error.call('SceneHeading') 		end
# line 74 "src/ragel/parser.rl"
when 16 then
# line 77 "src/ragel/parser.rl"
		begin
 classes= [SlugLine]; consume= true 		end
# line 77 "src/ragel/parser.rl"
when 17 then
# line 78 "src/ragel/parser.rl"
		begin
 error.call('SlugLine') 		end
# line 78 "src/ragel/parser.rl"
when 18 then
# line 81 "src/ragel/parser.rl"
		begin
 classes= [Transition]; consume= true 		end
# line 81 "src/ragel/parser.rl"
when 19 then
# line 82 "src/ragel/parser.rl"
		begin
 error.call('Transition') 		end
# line 82 "src/ragel/parser.rl"
when 20 then
# line 87 "src/ragel/parser.rl"
		begin
 classes= [TitlePage]; consume= true 		end
# line 87 "src/ragel/parser.rl"
when 21 then
# line 88 "src/ragel/parser.rl"
		begin
 error.call('TitlePage') 		end
# line 88 "src/ragel/parser.rl"
when 22 then
# line 92 "src/ragel/parser.rl"
		begin
 classes= [] 		end
# line 92 "src/ragel/parser.rl"
when 23 then
# line 93 "src/ragel/parser.rl"
		begin
 consume= true 		end
# line 93 "src/ragel/parser.rl"
# line 1128 "lib/eleanor/parser.rb"
			end # action switch
		end
	end
	if _trigger_goto
		next
	end
	end
	if _goto_level <= _again
	if cs == 0
		_goto_level = _out
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	if p == eof
	__acts = _parser_eof_actions[cs]
	__nacts =  _parser_actions[__acts]
	__acts += 1
	while __nacts > 0
		__nacts -= 1
		__acts += 1
		case _parser_actions[__acts - 1]
when 1 then
# line 46 "src/ragel/parser.rl"
		begin
 error.call('Action') 		end
# line 46 "src/ragel/parser.rl"
when 3 then
# line 50 "src/ragel/parser.rl"
		begin
 error.call('Action') 		end
# line 50 "src/ragel/parser.rl"
when 5 then
# line 54 "src/ragel/parser.rl"
		begin
 error.call('Dialog') 		end
# line 54 "src/ragel/parser.rl"
when 7 then
# line 58 "src/ragel/parser.rl"
		begin
 error.call('Insert') 		end
# line 58 "src/ragel/parser.rl"
when 9 then
# line 62 "src/ragel/parser.rl"
		begin
 error.call('MontageItem') 		end
# line 62 "src/ragel/parser.rl"
when 11 then
# line 66 "src/ragel/parser.rl"
		begin
 error.call('MontageHeading') 		end
# line 66 "src/ragel/parser.rl"
when 13 then
# line 70 "src/ragel/parser.rl"
		begin
 error.call('Parenthetical') 		end
# line 70 "src/ragel/parser.rl"
when 15 then
# line 74 "src/ragel/parser.rl"
		begin
 error.call('SceneHeading') 		end
# line 74 "src/ragel/parser.rl"
when 17 then
# line 78 "src/ragel/parser.rl"
		begin
 error.call('SlugLine') 		end
# line 78 "src/ragel/parser.rl"
when 19 then
# line 82 "src/ragel/parser.rl"
		begin
 error.call('Transition') 		end
# line 82 "src/ragel/parser.rl"
when 21 then
# line 88 "src/ragel/parser.rl"
		begin
 error.call('TitlePage') 		end
# line 88 "src/ragel/parser.rl"
# line 1211 "lib/eleanor/parser.rb"
		end # eof action switch
	end
	if _trigger_goto
		next
	end
end
	end
	if _goto_level <= _out
		break
	end
	end
	end
# line 135 "src/ragel/parser.rl"
          # collect lines until consume is set, i.e., we've seen a full
          # paragraph, in which case classes is non-nil
          lines << line
          if consume
            lines= lines.map { |l| l.strip }.reject { |l| l.empty? }
            unless lines.empty?
              if classes[0] == TitlePage
                @title_pages << TitlePage.new(:title   => lines[0],
                                              :author  => lines[1],
                                              :contact => lines[2..-1])
              else
                lines.each_with_index do |line, i|
                  @paras << classes[i].new(self, line, last_char_cue)
                  # remember the last character cue in the current scene
                  if classes[i] == CharacterCue
                    last_char_cue= @paras.last
                  elsif classes[i] == SceneHeading
                    last_char_cue= nil
                  end
                end
              end
            end
            lines= []
          end
        end
      end
      cs < parser_first_final ? nil : @paras
    end

  end

end
