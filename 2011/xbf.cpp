/*
 *	Project Name: eXtended BrainFuck interpreter
 *	Developer Name: Boro Sitnikovski
 *	Project Started: 20.01.2011
 *
 *	Project Version: v1.00
 *	Version Release: 25.01.2011
 *
 *	Project License:
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include <stdio.h>
#include <conio.h>

int atoi(char *str) {
	int x=0; char tmp;
	while (*str != '\0') {
		tmp = *str - '0';
		if (tmp >= 0 && tmp <= 9) {
			x += tmp;
			x*=10;
		}
		str++;
	}
	return x/10;
}

class BrainFuck {
	char *bf, *start;
	int memory;
	bool error, alter;

	int BF_Error(char *str) {
		printf("\nError: %s. Execution stopped.", str);
		error = true;
		return 0;
	}

	int BF_ParseCode(char *str) {
		int counter, i, j;
		char *tmp, *bftmp;

		for (i=0; str[i] != '\0'; i++)
			if (str[i] == '+') ++*bf;
			else if (str[i] == '}') ++*start;
			else if (str[i] == '-') --*bf;
			else if (str[i] == '{') --*start;
			else if (str[i] == '|') *bf = memory+(start-bf);

			else if (str[i] == '*') bf = start;
			else if (str[i] == '>') ++bf;
			else if (str[i] == '<') --bf;

			else if (str[i] == '.')	putch(*bf);
			else if (str[i] == ',') { *bf = getch(); putch(*bf); }
			else if (str[i] == ';') {
				FILE *t;
				t = fopen("xbf.out", "w+");
				if (!t) continue;
				counter = start - bf;
				if (counter < 0) counter=-counter;
				for (j=0; j<memory-counter; j++) fputc(bf[j], t);
				fclose(t);
			}
			else if (str[i] == ':') {
				FILE *t;
				char temp;
				t = fopen("xbf.in", "r");
				if (!t) continue;
				counter = start - bf;
				if (counter < 0) counter=-counter;
				temp = fgetc(t);
				for (j=0; j<memory-counter && !feof(t); j++) {
					bf[j] = temp;
					temp = fgetc(t);
				}
				fclose(t);
			}

			else if (str[i] == '#') return 0;
			else if (str[i] == '/') {
				counter = 0;
				for (j=i+1; str[j] != '\0'; j++)
					if (str[j] == '[') return BF_Error((char *)"Can't comment a line that opens a loop");
					else if (str[j] == ']')	return BF_Error((char *)"Can't comment a line that closes a loop");
					else if (str[j] == '!') return BF_Error((char *)"Can't comment a line that contains a position to jump to");
					else if (str[j] == '\r' || str[j] == '\n' || str[j] == '\0') { i = j; break; }
			}
			else if (str[i] == 'f') {
				counter = 0;
				for (j=i+1; str[j] != '\0'; j++)
					if (str[j] == '[') counter++;
					else if (str[j] == ']') counter--;
					else if (str[j] == '!' && counter == 0) {
						i = j;
						j = -1;
						break;
					}
				if (j == -1) continue;
				return BF_Error((char *)"Jump position not found");
			}
			else if (str[i+1] == 'b') {
				counter = 0;
				for (j=i-1; j >= 0; j--)
					if (str[j] == '[') counter++;
					else if (str[j] == ']') counter--;
					else if (str[j] == '!' && counter == 0) {
						i = j;
						j = -1;
						break;
					}
				if (j == -1) continue;
				return BF_Error((char *)"Jump position not found");
			}

			else if (str[i] == '=' && (*bf) == 0 && str[i+1] != '\0') i++;
			else if (str[i] == ')' && (*bf) > 0 && str[i+1] != '\0') i++;
			else if (str[i] == '(' && (*bf) < 0 && str[i+1] != '\0') i++;

			else if (str[i] == '[') {
				counter = 1;
				for (j=i+1; str[j] != '\0'; j++)
					if (counter == 0) break;
					else if (str[j] == '[') counter++;
					else if (str[j] == ']') counter--;

				if (counter != 0) return BF_Error((char *)"Brackets error");

				tmp = new char[j-i-1];
				for (counter=0; counter<j-i-2; counter++) tmp[counter] = str[i+1+counter];
				tmp[j-i-2] = '\0';

				i = j-1;

				if (alter) {
					bftmp = bf;
					while (*bftmp) if (BF_ParseCode(tmp) == 0) return 0;
				} else while (*bf) if (BF_ParseCode(tmp) == 0) return 0;

				delete tmp;
			}
			else if (str[i] == '~') alter = !alter;

		error = false;
		return 1;
	}

	public:

	BrainFuck(char *str, int memory) {
		this->memory = memory;
		alter = false;
		bf = start = new char[memory];
		for (int i=0; i<memory; i++) bf[i] = 0;
		BF_ParseCode(str);
	}

	~BrainFuck() {
		delete start;
	}

	bool Error() {
		return error;
	}
};

int main(int argc, char **argv) {
	int memory;
	FILE *input;
	char *str;
	int counter=0;

	printf("eXtended BrainFuck interpreter v1.0 by Boro Sitnikovski\n-------------------------------------------------------\n");

	if (argc != 3) {
		printf("Usage: %s <memory limit (int)> <filename.xbf>\n", argv[0]);
		return 0;
	}

	memory = atoi(argv[1]);
	input = fopen(argv[2], "r");

	if (!input) {
		printf("Error: Filename could not be opened. Execution stopped.\n");
		return 0;
	}

	while (!feof(input)) {
		fgetc(input);
		counter++;
	}

	rewind(input);
	str = new char[counter+1];
	counter=0;

	while (!feof(input)) str[counter++] = fgetc(input);
	fclose(input);
	str[counter-1] = '\0';

	BrainFuck(str, memory);

	delete str;
	return 0;
}