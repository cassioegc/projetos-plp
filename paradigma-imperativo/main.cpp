#include <iostream>
using namespace std;

#include <iostream>
using namespace std;


void decrement_points(int points, int & user_points) {
        user_points -= points;
}

void win_points(int & user_points, int points) {
        user_points += points;
}

void bonus_consequence(string level, int & user_points_lose, int & user_points_win) {
        int points;

        if (level == "PYTHON") {
                points = user_points_lose * 0.1;
                user_points_lose -= points;
                user_points_win += points;
        }
        else if (level == "JAVA") {
                points = user_points_lose * 0.15;
                user_points_lose -= points;
                user_points_win += points;
        }
        else {
                points = user_points_lose * 0.2;
                user_points_lose -= points;
                user_points_win += points;
        }
}

void error_consequence(string level, int & user_points, int & user_life) {
        
        if (level == "PYTHON") {
                decrement_points(2, user_points);
        }
        else if (level == "JAVA") {
                decrement_points(5, user_points);
        }
        else {
                decrement_points(8, user_points);
        }

        user_life -= 1;
}


int main() {

	string user1_name;
	string user2_name;
	int user1_points = 8;
	int user2_points;
	int user1_life;
	int user2_life;
	string level;
	
	return 0;
}
