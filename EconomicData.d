import std.stdio, std.string, std.regex, std.conv;

/**
* Struct to hold the options the user chose for what info they would like
* displayed.
*/
static struct UserOptions{
	int year;
	int choice;
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
	writeln("7 --> Some other bullshit for ", userYear);
	writeln("8 --> All of the above for ", userYear, "\n");
}

/**
* Pull data from the file based on the options chosen from the user
*/
void readFile(UserOptions uo, File file) {
	int year = uo.year;
	int choice = uo.choice;
	string fullRegex = format("[A-a-z]+,[-0-9]*,[-0-9]*,%s,[-0-9]*", year);
	string optionRegex;
	while (!file.eof()) {
		string line = chomp(file.readln());
		if (match(line, fullRegex)) {
			switch (choice) {
				default:
					throw new Exception("Invalid Number");
				case 1:
					optionRegex = "";
					writeln(year, " ", choice, " -->\t|\t", line);
					break;
				case 2:
					optionRegex = "";
					break;
				case 3:
					optionRegex = "";
					break;
				case 4:
					optionRegex = "";
					break;
				case 5:
					optionRegex = "";
					break;
				case 6:
					optionRegex = "";
					break;
				case 7:
					optionRegex = "";
					break;
				case 8:
					optionRegex = "";
					break;
			}
		}
	}
}

void main() {
	//promptUser will return the UserOptions struct
	readFile(promptUser(), File("exports_balance.txt", "r"));
}