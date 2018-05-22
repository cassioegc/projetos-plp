#include <bits/stdc++.h>
using namespace std;

typedef struct{
    int points;
    int lifes;
    string nickname;
}player;

typedef struct{
    string name;
}level;

void decrement_points(int points, player gamer) {
	gamer.points -= points;
}

void win_points(int points, player gamer) {
	gamer.points += points;
}

/* This function add lifes to the player
 */
void add_lifes(player gamer, level actual_level) {
        if (actual_level == "PYTHON") {
                gamer.lifes += 7;
        }
        else if (actual_level == "JAVA") {
                gamer.lifes += 5;
        }
        else if (actual_level == "ASSEMBLY") {
                gamer.lifes += 3;
        }
}

void require_bonus(level actual_level, player loser_player, player winner_player) {
	int points;

	if (actual_level.name == "PYTHON") {
		points = loser_player.points * 0.1;
		decrement_points(points, loser_player);
		win_points(points, winner_player);
	}
	else if (actual_level.name == "JAVA") {
		points = loser_player.points * 0.15;
		decrement_points(points, loser_player);
		win_points(points, winner_player);
	}
	else if (actual_level.name == "ASSEMBLY") {
		points = loser_player.points * 0.2;
		decrement_points(points, loser_player);
		win_points(points, winner_player);
	}
}

void penalize_player(level actual_level, player gamer) {
	if (actual_level.name == "PYTHON") {
		decrement_points(2, gamer);
	}
	else if (actual_level.name == "JAVA") {
		decrement_points(5, gamer);
	}
	else if (actual_level.name == "ASSEMBLY") {
		decrement_points(8, gamer);
	}
	gamer.lifes -= 1;
}


int main() {
    player player1, player2;
	level actual_level;
	bool state_game;
	int round_game;

	// INICIALIZANDO
	add_lifes(player1);
	add_lifes(player2);
	round_game = 0;
	state_game = player1.lifes == 0 || player2.lifes == 0;

	while (state_game) {
		

	}


	return 0;
}
