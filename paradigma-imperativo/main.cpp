#include <bits/stdc++.h>

using namespace std;

typedef struct{
    int points;
    int lifes;
    string id;
}player;

typedef struct{
    string name;
}level;

void decrement_points(int points, player p1) {
        p1.points -= points;
}

void win_points(int points, player p1) {
        p1.points += points;
}

void require_bonus(level l1, int player_points_lose, int player_points_win, player p1) {
        int points;

        if (l1.name == "PYTHON") {
                points = player_points_lose * 0.1;
                decrement_points(player_points_lose, p1);
                win_points(player_points_win, p1);
        }
        else if (l1.name == "JAVA") {
                points = player_points_lose * 0.15;
                decrement_points(player_points_lose, p1);
                win_points(player_points_win, p1);
        }
        else {
                points = player_points_lose * 0.2;
                decrement_points(player_points_lose, p1);
                win_points(player_points_win, p1);
        }
}

void penalize_player(string level, player p1) {

        if (level == "PYTHON") {
                decrement_points(2, p1);
        }
        else if (level == "JAVA") {
                decrement_points(5, p1);
        }
        else {
                decrement_points(8, p1);
        }

        p1.lifes -= 1;
}


int main() {
    player p1, p2;
	level l1;
	return 0;
}
