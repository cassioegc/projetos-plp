#include <bits/stdc++.h>
#include <unistd.h>

using namespace std;

int _NUMBER_WORDS = 1627;

typedef struct{
	int points;
	int lifes;
	string nickname;
	bool choose_letter;
	bool type_word;
	bool synonyms;
	bool syllables;
}player;

typedef struct{
	string name;
}level;

void inicialize_bonus(player &gamer) {
    gamer.choose_letter = true;
    gamer.type_word = true;
    gamer.synonyms = true;
    gamer.syllables = true;
}

void set_bonus(player &gamer, string type, bool value) {
    if (type == "letra") {
        gamer.choose_letter = value;
    } else if (type == "tipo") {
        gamer.type_word = value;
    } else if (type == "sinonimo") {
        gamer.synonyms = value;
    } else if (type == "silaba") {
        gamer.syllables = value;
    }
}

void add_points(player &gamer, level &actual_level) {
	if (actual_level.name == "PYTHON") {
		gamer.points += 20;
	} else if (actual_level.name == "JAVA") {
		gamer.points += 30;
	} else if (actual_level.name == "ASSEMBLY") {
		gamer.points += 50;
	}
}

/* Set level
*/
void set_level(level &actual_level, int round) {
	if (round <= 3) {
		actual_level.name = "PYTHON";
	} else if (round >= 4 && round <= 6) {
        actual_level.name = "JAVA";
	} else if (round >= 7 && round <= 10) {
        actual_level.name = "ASSEMBLY";
	}
}

void start_score(player &gamer1, player &gamer2) {
	gamer1.points = 0;
	gamer2.points = 0;
}

void start_life(player &gamer1, player &gamer2) {
	gamer1.lifes = 0;
	gamer2.lifes = 0;
}

/* This function add  to the player
 */

 void add_lifes(player &gamer, level &actual_level) {
	if (actual_level.name == "PYTHON") {
		gamer.lifes += 7;
	} else if (actual_level.name == "JAVA") {
		gamer.lifes += 5;
	} else if (actual_level.name == "ASSEMBLY") {
		gamer.lifes += 3;
	}
}

void transfer_points(level &actual_level, player &winner_player, player &loser_player) {
	int points;
	if (actual_level.name == "PYTHON") {
		points = loser_player.points * 0.1;
	} else if (actual_level.name == "JAVA") {
		points = loser_player.points * 0.15;
	} else if (actual_level.name == "ASSEMBLY") {
		points = loser_player.points * 0.2;
	}
	winner_player.points += points;
	loser_player.points -= points;
}

void  penalize_player(level actual_level, player &gamer) {
	int penalty;

	if (actual_level.name == "PYTHON") {
		penalty = 2;
	} else if (actual_level.name == "JAVA") {
		penalty = 5;
	} else if (actual_level.name == "ASSEMBLY") {
		penalty = 8;
	}

	gamer.lifes--;
	gamer.points -= penalty;
}

vector<int> contains(string actual_word, char letter) {
    vector<int> index;
    for (int i = 0; i < actual_word.size(); i++) {
        if (actual_word[i] == letter) {
            index.push_back(i);
        }
    }
    return index;
}

void update_status_of_word(vector<int> index, string &actual_status_of_word, char letter) {
	for (int i = 0; i < index.size(); i++) {
		actual_status_of_word[index[i]] = letter;
	}
}

/* Verifica se a letra esta na palavra,
 * e imprime a situacao da palavra no momento
*/
void verify_letter(player &gamer, char letter, level &actual_level, string actual_word, string &actual_status_of_word) {
	vector<int> index = contains(actual_word, letter);
	if (index.size() == 0) {
        cout << "A palavra nao possui essa letra! -1 tentativa,\n\n";
        penalize_player(actual_level, gamer);
	}

	update_status_of_word(index, actual_status_of_word, letter);
}

void model_word(int word_length, string &actual_status_of_word) {
	for (int i = 0; i < word_length; i++) {
		actual_status_of_word += "_";
	}
}

void player_status(player &gamer) {
	cout << "Status: " << gamer.nickname << endl;
	cout << "=> Tentativas restantes: " << gamer.lifes << endl;
	cout << "=> Total de pontos: " << gamer.points << endl;
}

void receive_letter(player &gamer, level &actual_level, string actual_word, string &actual_status_of_word){
    char letter;
    cout << gamer.nickname + ", digite uma letra: ";
    cin >> letter;
    cout << endl;
	verify_letter(gamer, letter, actual_level, actual_word, actual_status_of_word);
	player_status(gamer);
}

//========================FILES AREA============================

typedef struct{
	string word;
	vector<string> synonyms;
	vector<string> _class;
	int syllables;
}word_data;

vector<string> split(string s, char c) {
	string buff = "";
	vector<string> v;

	for(int i = 0; i < s.size(); i++)
	{
		if(s[i] != c) buff+=s[i]; else
		if(s[i] == c && buff != "") { v.push_back(buff); buff = ""; }
	}
	if(buff != "") v.push_back(buff);

	return v;
}

string get_line_data() {
    srand(time(NULL));
    int line = rand() % _NUMBER_WORDS + 1;
    ifstream file("dicionario.csv");
    string value;
    for (int i = 0; i < line; i++)
    {
         getline ( file, value, '\n' );
    }
    return value;
}

word_data get_word_data(string line_data) {
    word_data data_word;
    vector<string> data = split(line_data, ',');
    data_word.word = data[0];
    data_word.synonyms = split(data[1], '.');
    data_word._class = split(data[2], '.');
    data_word.syllables = split(data[3], '-').size();

    return data_word;
}

// Utils
void to_string_vector(vector<string> v) {
    for (int i = 0; i < v.size(); i++) {
        cout << v[i];
        if (i < v.size()-1) {
            cout << ", ";
        }
    }
    cout << endl;
}

// Utils
void to_string_word_data(word_data w) {
    cout << "Palavra: " << w.word << endl;
    cout << "Sinonimo: ";
    to_string_vector(w.synonyms);
    cout << "Classes: ";
    to_string_vector(w._class);
    cout << "Silabas: " << w.syllables << endl;
}

//===========================FILES AREA=================================

string selection_word(word_data data) {
	string word = data.word;
	cout << endl << "Sorteando a palavra..." << endl << endl;
	//sleep(2);
	return word;
}

bool compare_words(string actual_word, player &actual_player, level &actual_level) {
    bool result;
    string word;
    cin >> word;
    if (actual_word != word) {
        result = false;
        penalize_player(actual_level, actual_player);
        cout << "Palavra errada :(" << endl << endl;
    } else {
        result = true;
        cout << "Parabens!!" << endl;
        cout << "Proxima rodada.." << endl;
    }
    return result;
}

bool complete_word(player &gamer, string &actual_word, int &covered_size, level &actual_level) {
    bool result;
    if (covered_size >= actual_word.size() * 0.4) {
        cout << gamer.nickname + ", Digite a palavra completa: ";
        result = compare_words(actual_word, gamer, actual_level);
    }
    return result;
}

void update_covered_size(int &covered_size, string &actual_word, string &actual_status_of_word) {
    covered_size = actual_word.size() - contains(actual_status_of_word, '_').size();
}

void update_state_game(bool &state_game, player &player1, player &player2) {
    state_game = player1.lifes == 0 || player2.lifes == 0;
}

void select_bonus(int value, player &gamer, string &actual_word) {
    if (value == 1 && !gamer.choose_letter) {
        // inserir manipulacao
    } else if (value == 2 && !gamer.type_word) {
        // inserir manipulacao
    } else if (value == 3 && !gamer.synonyms) {
        // inserir manipulacao
    } else if (value == 4 && !gamer.syllables) {
        // inserir manipulacao
    } else if (value > 0 && value < 5){
        cout << "Esse bonus ja foi utilizado!" << endl << endl;
    } else {
        cout << "Opcao invalida" << endl << endl;
    }
}

void menu(player &gamer, level &actual_level, string &actual_word, string &actual_status_of_word) {
    cout << "============/// ESTADO ATUAL DA PALAVRA ///================" << endl;
    cout << "NIVEL: " + actual_level.name << endl;
    cout << "PALAVRA:  " + actual_status_of_word << endl << endl;

    cout << "====================== SUAS OPCOES ========================" << endl;
    cout << "~~~~~~~~~> " + gamer.nickname << endl;
    cout << "0. Escolher uma letra" << endl;
    cout << "1. Usar bonus" << endl << endl;
    int option;
    cout << "R: ";
    cin >> option;

    if (option == 1) {
        int bonus;
        cout << "======================= SEUS BONUS ========================" << endl;
        if (gamer.choose_letter) {
            cout << "1. Escolher uma letra sem sofrer penalidade em caso de erro" << endl;
        }
        if (gamer.type_word) {
            cout << "2. Solicitar o tipo da palavra" << endl;
        }
        if (gamer.synonyms) {
            cout << "3. Solicitar sinonimo" << endl;
        }
        if (gamer.syllables) {
            cout << "4. Pedir a quantidade de silabas da palavra" << endl;
        }
        cout << "===========================================================" << endl;
        cout << "R: ";
        cin >> bonus;
        select_bonus(bonus, gamer, actual_word);

    } else if (option == 0) {
        receive_letter(gamer, actual_level, actual_word, actual_status_of_word);
    } else {
        cout << "Opcao invalida!" << endl;
    }
}

void reset_words(string &actual_word, string &actual_status_of_word) {
    actual_word = "";
    actual_status_of_word = "";
}

void played(player &player1, player &player2, player actual_player, level &actual_level, string &actual_word, string &actual_status_of_word, int &covered_size, bool &state_game, int &round_game, bool &checked) {
    menu(player1, actual_level, actual_word, actual_status_of_word);
		actual_player = player1;
		cout << "RODADA: " << round_game << " => " << actual_status_of_word << endl << endl;
		update_covered_size(covered_size, actual_word, actual_status_of_word);
		checked = complete_word(actual_player, actual_word, covered_size, actual_level);
		if (checked) {
            round_game += 1;
            set_level(actual_level, round_game);
            add_lifes(player1, actual_level);
            add_points(player1, actual_level);
            reset_words(actual_word, actual_status_of_word);
            string line_data = get_line_data();
            word_data actual_word_data = get_word_data(line_data);
            actual_word = selection_word(actual_word_data);
            model_word(actual_word.size(), actual_status_of_word);
		}
	update_state_game(state_game, player1, player2);
}

int main() {
	// VARIAVEIS
	player player1, player2;
	level actual_level;
	bool state_game;
	int round_game;
	string actual_word;
	string actual_status_of_word;
	int number_word = 1370;
    player actual_player;
    int covered_size = 0;
    bool checked = false;

	// INICIALIZANDO AS VARIAVEIS DOS JOGADORES
	round_game = 1;
    set_level(actual_level, round_game);
    start_score(player1, player2);
    start_life(player1, player2);
	add_lifes(player1, actual_level);
	add_lifes(player2, actual_level);
	add_points(player1, actual_level);
	add_points(player2, actual_level);
	inicialize_bonus(player1);
	inicialize_bonus(player2);

	// DADOS JOGADOR
	cout << "Nome jogador 1: ";
	cin >> player1.nickname;
	cout << "Nome jogador 2: ";
	cin >> player2.nickname;

	update_state_game(state_game, player1, player2);
	string line_data = get_line_data();
  	word_data actual_word_data = get_word_data(line_data);
  	actual_word = selection_word(actual_word_data);
	model_word(actual_word.size(), actual_status_of_word);

	while (!state_game) {
        // PLAYER 1
        played(player1, player2, actual_player, actual_level, actual_word, actual_status_of_word, covered_size, state_game, round_game, checked);
		// system("clear");

		// PLAYER 2
        played(player2, player1, actual_player, actual_level, actual_word, actual_status_of_word, covered_size, state_game, round_game, checked);
		// system("clear");
	}
	return 0;
}
