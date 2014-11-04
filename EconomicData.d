import std.stdio, std.string, std.regex, std.conv, std.algorithm;

/**
* Struct to hold the options the user chose for what info they would like
* displayed.
*/
static struct UserOptions{
	int year;
	int choice;
}

/**
*Struct to be able to compare the desired data and add country and data
*to the RBT tree so it can be displayed to the user in a readable manner
*/
struct CountryWithData {
	string country;
	string data;
}

/**
* Prompt the user to choose a year and what information he wants from the file.
* Return theh UserOptions struct so that readFile knows what data to pull from
* the file.
*/
UserOptions promptUser() {
	writeln("\nPlease enter a valid year between 1986 and 2006" 
		" in which you would like to see the Economic data printed for:");
	int userYear;

	readf(" %s", &userYear);
	while(userYear < 1986 || userYear > 2006) {
		writeln("\nPlease enter a valid year between 1986 and 2006:");
		readf(" %s", &userYear);
	}

	//Instantiate struct so that values can be set based on user input
	UserOptions uo;
	uo.year = userYear;

	writeln("\nThank you for choosing the year: ", userYear, "\nPlease choose"
		" a number below for information you would like displayed.\n");
	printUserChoices(userYear);

	int infoChoice;

	readf(" %s", &infoChoice);

	while(infoChoice < 1 || infoChoice > 8) {
		writeln("\nPlease choose a valid option (1-8)\nHere are"
			" your options\n\n");
		printUserChoices(userYear);
		readf(" %s", &infoChoice);
	}
	uo.choice = infoChoice;

	return uo;
}

/**
* Print the options the user has to the console.
*/
void printUserChoices(int userYear) {
	writeln("1 --> Top 5 exporting countries for ", userYear);
	writeln("2 --> Worst 5 exporting countries for ", userYear);
	writeln("3 --> Top 5 countries by balance of trade for ", userYear);
	writeln("4 --> Worst 5 countries by balance of trade for ", userYear);
	writeln("5 --> 5 countries with best ratio of exports to balance of trade"
		" for ", userYear);
	writeln("6 --> 5 countries with the worst ratio of exports to balance of"
		" trade for ", userYear);
	writeln("7 --> 5 most populated countries for ", userYear);
}

/**
* Pull data from the file based on the options chosen from the user
*/
CountryWithData[] readFile(UserOptions uo, File file) {
	int year = uo.year;
	int choice = uo.choice;
	string fullRegex = format("[A-Za-z]+,[-0-9]*,[-0-9]*,%s,[-0-9]*", year);
	string[] lineSplit = new string[](6);
	CountryWithData[] sortedArray;
	int index = 0;
	while (!file.eof()) {
		CountryWithData cwd;
		string line = chomp(file.readln());
		if (match(line, fullRegex)) {
		lineSplit = split(line, ",");
			switch (choice) {
				default:
					//Number was already confirmed in promptUser
					throw new Exception("Invalid Number");
				case 1:
				case 2:
					cwd.data = lineSplit[1];
					break;
				case 3:
				case 4:
					cwd.data = lineSplit[2];
					break;
				case 5:
				case 6:
					auto a = to!double(lineSplit[1]);
					auto b = to!double(lineSplit[2]);
					auto c = to!string(a / b);
					cwd.data = c;
					break;
				case 7:
					cwd.data = lineSplit[4];
					break;
			}
			cwd.country = lineSplit[0];
			++sortedArray.length;
			sortedArray[index] = cwd;
			index++;
		}
	}
	sortedArray.sort!q{ to!int(a.data) > to!int(b.data) };
	return sortedArray;
}

void main() {
	//promptUser will return the UserOptions struct
	CountryWithData[] sortedArray =
		readFile(promptUser(), File("exports_balance.txt", "r"));
		switch(UserOptions.choice) {
			case 1:
				break;
			case 2:
				break;
			case 3:
				break;
			case 4:
				break;
			case 5:
				break;
			case 7:
				break;
			default:
				throw new Exception("Invalid Choice");
		}
}