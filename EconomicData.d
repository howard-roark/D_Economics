import std.stdio, std.string, std.regex, std.conv, std.algorithm, std.datetime;
import core.stdc.stdlib;

/**
* Struct to hold the year and what data the user would like displayed
*/
struct UserOptions{
	int year;
	static int choice;
}

/**
* Struct to hold the country and what data is being sought by the user, used
* when building and sorting the array that will hold the data.
*/
struct CountryWithData {
	string country;
	string data;
}

/**
* Prompt the user for what year they would like to query and what data they are
* looking for.
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
* Method to print user choices, may be called from multiple locations if the user
* enters an invalid choice.
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
* Read the data file with all of the economic information that needs to be sorted
* based on user input options chosen.
*/
string[] readFile(UserOptions uo, File file) {
	int year = uo.year;
	string fullRegex = format("[A-Za-z]+,[-0-9]*,[-0-9]*,%s,[-0-9]*", year);
	string[] unSortedArray;
	int index = 0;
	while (!file.eof()) {
		string line = chomp(file.readln());
		if (match(line, fullRegex)) {
			++unSortedArray.length;
			unSortedArray[index] = line;
			index++;
		}
	}
	return unSortedArray;
}

CountryWithData[] sortCWDArray(string[] unSortedArray) {
	int choice = UserOptions.choice;
	int index = 0;
	string[] lineSplit = new string[](6);
	CountryWithData[] sortedArray;
	for (int i = 0; i < unSortedArray.length; i++) {
		CountryWithData cwd;
		lineSplit = split(unSortedArray[i], ",");
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
    auto startTime = Clock.currTime();
	sortedArray.sort!q{ to!int(a.data) > to!int(b.data) };
    auto finishTime = Clock.currTime();
    writeln("\nSort took: ", finishTime - startTime);
	return sortedArray;
}

/**
* Print the results from what the user was looking for.
*/
void printResults(CountryWithData[] cwd) {
	int choice = UserOptions.choice;
	switch (choice) {
		default:
			throw new Exception("Invalid Number");
		case 1:
		case 3:
		case 5:
		case 7:
		for (int i = 0; i < 5; i++) {
			writeln(cwd[i].country, ":  ", cwd[i].data);
		}
			break;
		case 2:
		case 4:
		case 6:
		for (auto i = cwd.length - 1; i > cwd.length - 6; i--) {
			writeln(cwd[i].country, ":  ", cwd[i].data);
		}
			break;
	}
}

/**
* Main method to drive program.
*/
void main() {
	writeln("\nWelcome to Economic Data Info!");
	printResults(
		sortCWDArray(
			readFile(
				promptUser(), File("exports_balance.txt", "r"))));
	writeln("\nPlease press \'Y\' to request more info or \'N\' to Exit");
	char choice;
	readf(" %s", &choice);
	while (choice != 'Y' && choice != 'y' && choice != 'N' && choice != 'n') {
		writeln("Invalid choice:"
			"\nPlease press \'Y\' to request more info or \'N\' to Exit");
		readf(" %s", &choice);
	}
	if (choice == 'Y' || choice == 'y') {
		main();
	} else {
		writeln("Thank you for visiting, Goodbye");
		exit(0);
	}
}