#include <iostream>
#include <fstream>
#include <set>
#include <map>
#include <vector>
#include <sstream>

using namespace std;

/** HELPERS **/
const string WHITESPACE = " \n\r\t\f\v";
 
void print_set(set<char> s) {
	cout << '(';
	for (auto it = s.begin(); it != s.end(); ++it) {
		cout << *it << ", ";
	}
	cout << ')' << endl;
}

string ltrim(const string &s)
{
    size_t start = s.find_first_not_of(WHITESPACE);
    return (start == string::npos) ? "" : s.substr(start);
}
 
string rtrim(const string &s)
{
    size_t end = s.find_last_not_of(WHITESPACE);
    return (end == string::npos) ? "" : s.substr(0, end + 1);
}
 
string trim(const string &s) {
    return rtrim(ltrim(s));
}

vector<string> split(const string &s, char delim) {
	stringstream ss(s);
	string item;
	vector<string> elems;
	while (getline(ss, item, delim)) {
		elems.push_back(item);
	}
	return elems;
}

set<char> string_to_set(string s) {
	set<char> chars;

	for (char c : s) {
	  chars.insert(c);
	}

	return chars;
}

template<class T>
set<T> operator -(set<T> reference, set<T> items_to_remove) {
	set<T> result;
	set_difference(
		reference.begin(), reference.end(),
		items_to_remove.begin(), items_to_remove.end(),
		inserter(result, result.end()));
	return result;
}

template<class T>
set<T> operator +(set<T> reference, set<T> items_to_remove) {
	set<T> result;
	set_union(
		reference.begin(), reference.end(),
		items_to_remove.begin(), items_to_remove.end(),
		inserter(result, result.end()));
	return result;
}

template<class T>
set<T> operator *(set<T> reference, set<T> items_to_remove) {
	set<T> result;
	set_intersection(
		reference.begin(), reference.end(),
		items_to_remove.begin(), items_to_remove.end(),
		inserter(result, result.end()));
	return result;
}

/* CODE STARTS HERE */
map<int, set<char>> find_digits(vector<set<char>> &sets) {
	map<int, set<char>> digits;

	// Easily determine 1, 4, 7, 8
	for (auto it : sets) {
		if (it.size() == 2) digits[1] = it;
		else if (it.size() == 4) digits[4] = it;
		else if (it.size() == 3) digits[7] = it;
		else if (it.size() == 7) digits[8] = it;
	}

	// Now determine 3 and 6 which are dependent on 1 and 7
	for (auto it : sets) {
		if ((it - digits[1]).size() == 3) digits[3] = it;
		else if ((it - digits[7]).size() == 4 && it != digits[8]) digits[6] = it;
	}

	// 9 is dependent on 3 and 4
	digits[9] = digits[3] + digits[4];

	for (auto it : sets) {
		// 5 is dependent on 6
		if (digits[6] * it == it && it != digits[6]) {
			digits[5] = it;
		}
		// 0 is dependent on 8, 6, and 9
		else if ((digits[8] * it).size() == 6 && it != digits[6] && it != digits[9]) {
			digits[0] = it;
		}
	}

	// Finally, 2 is dependent on the previous ones
	for (auto it : sets) {
		if (it != digits[0] && it != digits[8] && (it - digits[5]).size() == 2) {
			digits[2] = it;
			break;
		}
	}

	return digits;
}

int calculate_number(set<char> s, map<int, set<char>> &digits) {
	for (auto it = digits.begin(); it != digits.end(); it++) {
		if (it->second == s) {
			return it->first;
		}
		//print_set(it->second);
	}
	return 0;
}

vector<set<char>> parse_string(string s) {
	vector<string> elems = split(s, ' ');
	vector<set<char>> sets;
	for (string s : elems) {
		sets.push_back(string_to_set(s));
	}
	return sets;
}

int calculate_line(string s) {
	vector<string> elems = split(s, '|');

	// List of set of chars
	auto first = parse_string(trim(elems[0]));

	// Construct the map of int -> set of chars for the corresponding information. E.g. 1 -> ab, 4 -> eafb etc.
	auto digits = find_digits(first);

	auto second = parse_string(trim(elems[1]));

	int num = 0;
	for (auto it = second.begin(); it != second.end(); it++) {
		int tmp = calculate_number(*it, digits);
		num = (num + tmp)*10;
	}

	return num/10;
}


int main() {

	ifstream input( "input" );

	auto sum = 0;
	for ( string line; getline(input, line); ) {
		sum += calculate_line(line);
	}

	cout << sum << endl;
}
