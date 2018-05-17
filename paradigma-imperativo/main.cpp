#include <iostream>
using namespace std;

#include <iostream>
using namespace std;


void decrement_points(int points, int & player_points) {
        player_points -= points;
}

void win_points(int points, int & player_points) {
        player_points += points;
}

void require_bonus(string level, int & player_points_lose, int & player_points_win) {
        int points;

        if (level == "PYTHON") {
                points = player_points_lose * 0.1;
                decrement_points(points, player_points_lose);
                win_points(points, player_points_win);
        }
        else if (level == "JAVA") {
                points = player_points_lose * 0.15;
                decrement_points(points, player_points_lose);
                win_points(points, player_points_win);
        }
        else {
                points = player_points_lose * 0.2;
                decrement_points(points, player_points_lose);
                win_points(points, player_points_win);
        }
}

void penalize_player(string level, int & player_points, int & player_life) {
        
        if (level == "PYTHON") {
                decrement_points(2, player_points);
        }
        else if (level == "JAVA") {
                decrement_points(5, player_points);
        }
        else {
                decrement_points(8, player_points);
        }

        player_life -= 1;
}


int main() {

	string player1_name;
	string player2_name;
	int player1_points = 8;
	int player2_points;
	int player1_life;
	int player2_life;
	string level;
	
	return 0;
}
