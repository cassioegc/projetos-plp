#ifdef _WIN32
    #define clear_comand "CLS"
    #include <Windows.h>
    void so_sleep(float time) { Sleep(time * 1000); }
#endif // _WIN32

#ifdef __unix
    #include <unistd.h>
    #include <sys/ioctl.h>
    #define clear_comand "clear"
    void so_sleep(float time) { usleep(time * 1000000); }
#endif // __unix__

#include <bits/stdc++.h>

using namespace std;

#define _NUMBER_WORDS 1627
int LINHAS, COLUNAS;

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

string repeat(char chr, int x) {
    string str = "";
    for (int i = 0; i < x; i++) {
        str += chr;
    }
    return str;
}

int to_int(char chr) {
  int result = chr-'0';
  return result;
}

bool is_numeric(char chr) {
  return int(chr) >= 48 and int(chr) <= 57;
}

void wait(string message, float tempo) {
    system(clear_comand);
    int size_original_msg = message.size();
    cout << repeat('\n', (LINHAS-1)/2);
    cout << repeat(' ', (COLUNAS-size_original_msg)/2) << message << endl;
    for (int i = 0; i < 5; i++) {
      message += ".";
      system(clear_comand);
      cout << repeat('\n', (LINHAS-1)/2);
      cout << repeat(' ', (COLUNAS-size_original_msg)/2) << message << endl;
      so_sleep(tempo);
    }
    so_sleep(1);
    system(clear_comand);
}

void fade_word(string msg) {
  string message = "";
  int size_msg = msg.size();
  system(clear_comand);
  cout << repeat(' ', (COLUNAS-size_msg)/2) << message << endl;
  so_sleep(1);
  for (int i = 0; i < size_msg; i++) {
    message += "_";
    system(clear_comand);
    cout << repeat(' ', (COLUNAS-size_msg)/2) << message << endl;
    so_sleep(0.1);
  }
  system(clear_comand);
}

void inicialize_bonus(player &gamer) {
    gamer.choose_letter = true;
    gamer.type_word = true;
    gamer.synonyms = true;
    gamer.syllables = true;
}

void set_bonus(player &gamer, string type, bool value) {
    if (type == "choose_letter") {
        gamer.choose_letter = value;
    } else if (type == "type_word") {
        gamer.type_word = value;
    } else if (type == "synonyms") {
        gamer.synonyms = value;
    } else if (type == "syllables") {
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
void verify_letter(player &gamer, char letter, level &actual_level, string actual_word, string &actual_status_of_word, bool penalize) {
	vector<int> index = contains(actual_word, letter);
	if (index.size() == 0) {
        cout << "            A palavra nao possui essa letra!" << endl << endl;
        if (penalize) {
            penalize_player(actual_level, gamer);
        }
	}

	update_status_of_word(index, actual_status_of_word, letter);
}

void model_word(int word_length, string &actual_status_of_word) {
	for (int i = 0; i < word_length; i++) {
		actual_status_of_word += "_";
	}
}

void player_status(player &gamer) {
    cout << "======================== STATUS ===========================" << endl;
	cout << "===> PLAYER: " << gamer.nickname << endl;
	cout << "===> TENTATIVAS RESTANTES: " << gamer.lifes << endl;
	cout << "===> SUBTOTAL DE PONTOS: " << gamer.points << endl;
}

void receive_letter(player &gamer, level &actual_level, string actual_word, string &actual_status_of_word, bool penalize){
    char letter;
    cout << endl << gamer.nickname + ", digite uma letra: ";
    cin >> letter;
    cout << endl;
	verify_letter(gamer, letter, actual_level, actual_word, actual_status_of_word, penalize);
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

int get_lower_limit(string level) {
    int result;
    if (level == "ASSEMBLY") {
        result = 10;
    }
    else {
        result = 2;
    }
    return result;
}

int get_upper_limit(string level) {
    int result;
    if (level == "PYTHON") {
        result = 10;
    }
    else if (level == "JAVA") {
        result = 15;
    }
    else {
        result = 20;
    }
    return result;
}

string get_line_data(level actual_level) {
    string level = actual_level.name;
    int word_size_limit_up = get_upper_limit(level);
    int word_size_limit_lw = get_lower_limit(level);

    string value;
    string word;
    do
    {
        srand(time(NULL));
        int line = rand() % _NUMBER_WORDS + 1;
        ifstream file("dicionario.csv");

        for (int i = 0; i < line; i++)
        {
            getline ( file, value, '\n' );
        }
        vector<string> data = split(value, ',');
        word = data[0];
    } while ((word.size() < word_size_limit_lw) || (word.size() > word_size_limit_up));

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
	cout << endl << "================= SORTEANDO A PALAVRA =====================" << endl << endl;
	//sleep(2);
	return word;
}

bool compare_words(string actual_word, player &actual_player, level &actual_level) {
    bool result;
    string word;
    cin >> word;
    cout << endl << "===========================================================" << endl;
    if (actual_word != word) {
        result = false;
        penalize_player(actual_level, actual_player);
        cout << "               ERRROOOOOOOWW, PUTZA VIDA :'(" << endl << endl;
    } else {
        result = true;
        cout << "             OLOCO BICHO, BRINCADEIRA MEU!!" << endl;
        cout << "                    Proxima rodada.." << endl;
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
    state_game = player1.lifes < 1 || player2.lifes < 1;
}

string get_first_element_list(vector<string> &word_list) {
    string result = "";
    result = word_list[0];
    if (word_list.size() > 1) {
        word_list.erase(word_list.begin());
    }
    return result;
}

void select_bonus(int value, player &gamer, string &actual_word, word_data &actual_word_data) {
    cout << endl << "===========================================================" << endl;
    if (value == 2 && gamer.type_word) {
        cout << "TIPO DA PALAVRA: " << get_first_element_list(actual_word_data._class) << endl;
        set_bonus(gamer, "type_word", false);
    } else if (value == 3 && gamer.synonyms) {
        cout << "SINONIMO: "  << get_first_element_list(actual_word_data.synonyms) << endl;
        set_bonus(gamer, "synonyms", false);
    } else if (value == 4 && gamer.syllables) {
        cout << "QUANTIDADE DE SILABAS: "  << actual_word_data.syllables << endl;
        set_bonus(gamer, "syllables", false);
    } else if (value > 0 && value < 5){
        cout << "Esse bonus ja foi utilizado!" << endl << endl;
    } else {
        cout << "Opcao invalida" << endl << endl;
    }
}

void inicialize_menu() {
    cout << "===========================================================" << endl;
    cout << "|               FORCA, RODA jequiti A RODA                |" << endl;
    cout << "===========================================================" << endl << endl;

    cout << "--------------------- COMO FUNCIONA -----------------------" << endl;
    cout << "REGRAS AQUI" << endl;
    cout << "REGRAS AQUI" << endl;
    cout << "REGRAS AQUI" << endl;
    cout << "REGRAS AQUI" << endl << endl;

    cout << "              Pressione enter para continuar" << endl;
    cin.ignore();
    system(clear_comand);

}

void end_menu(player &player1, player &player2) {
    cout << "===========================================================" << endl << endl;
    cout << "--------------------- FIM DE JOGO -------------------------" << endl << endl;
    cout << "~~~~~~~~~~~~~~~~~~ E O VENCEDOR FOI ~~~~~~~~~~~~~~~~~~~~~~~" << endl << endl;
    //sleep(1);
    so_sleep(2);
    if (player1.points > player2.points) {
        cout << player1.nickname + ", PARABENS!!" << endl;
	} else if (player2.points > player1.points) {
	    cout << player2.nickname + ", PARABENS!!" << endl;
	} else {
        cout << "OS DOIS!, HOUVE UM EMPATE, PARABENS! " << player1.nickname + ", " << player2.nickname << endl;
	}
}

void resume_players(player &player1, player &player2) {
    cout << "================== RESUMO DA PARTIDA ======================" << endl << endl;

    cout << "JOGADOR 1: " + player1.nickname << endl;
    cout << "TOTAL DE PONTOS: " << player1.points << endl;
    so_sleep(1);
    cout << "-----------------------------------------------------------" << endl;
    cout << "JOGADOR 2: " + player2.nickname << endl;
    cout << "TOTAL DE PONTOS: " << player2.points << endl;
}

void menu(player &gamer, level &actual_level, string &actual_word, string &actual_status_of_word, word_data &actual_word_data) {
    cout << "============/// ESTADO ATUAL DA PALAVRA ///================" << endl;
    cout << "NIVEL: " + actual_level.name << endl;
    cout << "PLAYER: " + gamer.nickname << endl;
    cout << "PALAVRA:  " + actual_status_of_word << endl << endl;

    cout << "====================== SUAS OPCOES ========================" << endl;
    cout << "0. Escolher uma letra" << endl;
    cout << "1. Usar bonus" << endl << endl;

    int option;
    cout << "R: ";
    cin >> option;

    if (option == 1) {
        int bonus;
        cout << endl << "======================= SEUS BONUS ========================" << endl;
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

        // CONDICAO PARA O PRIMEIRO BONUS, POIS EXIGE QUE O USUARIO NAO SOFRA PENALIZACAO
        if (bonus == 1 && gamer.choose_letter) {
            receive_letter(gamer, actual_level, actual_word, actual_status_of_word, false);
            cout << " ==> " << actual_status_of_word << endl << endl;
            set_bonus(gamer, "choose_letter", false);
        } else {
            select_bonus(bonus, gamer, actual_word, actual_word_data);
        }
        receive_letter(gamer, actual_level, actual_word, actual_status_of_word, true);
    } else if (option == 0) {
        receive_letter(gamer, actual_level, actual_word, actual_status_of_word, true);
    } else {
        cout << "Opcao invalida!" << endl;
    }
}

void reset_words(string &actual_word, string &actual_status_of_word) {
    actual_word = "";
    actual_status_of_word = "";
}

void played(player &player1, player &player2, level &actual_level, string &actual_word, string &actual_status_of_word, int &covered_size, bool &state_game, int &round_game, bool &checked, word_data &actual_word_data) {
    menu(player1, actual_level, actual_word, actual_status_of_word, actual_word_data);
    cout << "RODADA: " << round_game << " => " << actual_status_of_word << endl << endl;

    update_covered_size(covered_size, actual_word, actual_status_of_word);
    checked = complete_word(player1, actual_word, covered_size, actual_level);
    if (checked) {
        round_game += 1;
        set_level(actual_level, round_game);
        add_lifes(player1, actual_level);
        add_lifes(player2, actual_level);
        add_points(player1, actual_level);
        add_points(player2, actual_level);
        reset_words(actual_word, actual_status_of_word);
        string line_data = get_line_data(actual_level);
        actual_word_data = get_word_data(line_data);
        actual_word = selection_word(actual_word_data);
        model_word(actual_word.size(), actual_status_of_word);
        inicialize_bonus(player1);
        inicialize_bonus(player2);
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

	// INICIANDO MENU
	inicialize_menu();
    system(clear_comand);

	// DADOS JOGADOR
	cout << "================== INICIANDO PARTIDA ======================" << endl;
	cout << "NOME JOGADOR 1: ";
	cin >> player1.nickname;
	cout << "NOME JOGADOR 2: ";
	cin >> player2.nickname;

	update_state_game(state_game, player1, player2);
	string line_data = get_line_data(actual_level);
  	word_data actual_word_data = get_word_data(line_data);
  	actual_word = selection_word(actual_word_data);
	model_word(actual_word.size(), actual_status_of_word);

	while (!state_game) {
        played(player1, player2, actual_level, actual_word, actual_status_of_word, covered_size, state_game, round_game, checked, actual_word_data);
		so_sleep(2.5);
		system(clear_comand);

        played(player2, player1, actual_level, actual_word, actual_status_of_word, covered_size, state_game, round_game, checked, actual_word_data);
		so_sleep(2.5);
		system(clear_comand);
	}
	end_menu(player1, player2);
	resume_players(player1, player2);
	return 0;
}
