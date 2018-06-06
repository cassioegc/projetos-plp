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
int CENTRALIZE = 48;

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

void clear_screen() {
    system(clear_comand);
}

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
      clear_screen();
      cout << repeat('\n', (LINHAS-1)/2);
      cout << repeat(' ', (COLUNAS-size_original_msg)/2) << message << endl;
      so_sleep(tempo);
    }
    so_sleep(1);
    clear_screen();
}

void fade_word(string msg) {
  string message = "";
  int size_msg = msg.size();
  clear_screen();
  cout << repeat(' ', (COLUNAS-size_msg)/2) << message << endl;
  so_sleep(1);
  for (int i = 0; i < size_msg; i++) {
    message += "_";
    clear_screen();
    cout << repeat(' ', (COLUNAS-size_msg)/2) << message << endl;
    so_sleep(0.1);
  }
  clear_screen();
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

void model_word(int word_length, string &actual_status_of_word) {
	for (int i = 0; i < word_length; i++) {
		actual_status_of_word += "_";
	}
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
    wait("SORTEANDO PALAVRA", 0.4);
	return word;
}

bool compare_words(string actual_word, string word, player &actual_player, level &actual_level) {
    bool result;
    string status;
    if (actual_word != word) {
        result = false;
        penalize_player(actual_level, actual_player);
        status = "ERRROOOOOOOWW, PUTZA VIDA :'(\n\n";
        status = "\n" + repeat(' ', (COLUNAS-status.size())/2) + status;
    } else {
        result = true;
        status = "OLOCO BICHO, BRINCADEIRA MEU!!\n";
        status = "\n" + repeat(' ', (COLUNAS-status.size())/2) + status;
        string comp = "Proxima rodada..\n";
        status += repeat(' ', (COLUNAS-comp.size())/2) + comp;
    }
    cout << status;
    so_sleep(3);
    return result;
}

bool complete_word(player &gamer, string &actual_word, int &covered_size, level &actual_level) {
    bool result;
    string word_player;
    
    if (covered_size >= actual_word.size() * 0.4) {
        cout << repeat(' ', (COLUNAS-CENTRALIZE)/2) << gamer.nickname + ", Digite a palavra completa: ";
        cin >> word_player;
        result = compare_words(actual_word, word_player, gamer, actual_level);
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
    string espacos = repeat(' ', (COLUNAS-CENTRALIZE)/2);
    if (value == 2 && gamer.type_word) {
        cout << espacos << "TIPO DA PALAVRA: " << get_first_element_list(actual_word_data._class) << endl;
        set_bonus(gamer, "type_word", false);
    } else if (value == 3 && gamer.synonyms) {
        cout << espacos << "SEMELHANTE: "  << get_first_element_list(actual_word_data.synonyms) << endl;
        set_bonus(gamer, "synonyms", false);
    } else if (value == 4 && gamer.syllables) {
        cout << espacos << "QUANTIDADE DE SILABAS: "  << actual_word_data.syllables << endl;
        set_bonus(gamer, "syllables", false);
    } else if (value > 0 && value < 5){
        cout << espacos << "Esse bonus ja foi utilizado!" << endl << endl;
    } else {
        cout << espacos << "Opcao invalida" << endl << endl;
    }
}

string inicialize_menu() {
    string menu = "===========================================================\n";
    string espacos = repeat(' ', (COLUNAS - menu.size())/2); 
    menu = espacos + menu;   
    menu += espacos + "|               FORCA, RODA jequiti A RODA                |\n";
    menu += espacos + "===========================================================\n" ;
    menu += espacos + "--------------------- COMO FUNCIONA -----------------------\n";
    menu += espacos + "REGRAS AQUI\n";
    menu += espacos + "REGRAS AQUI\n";
    menu += espacos + "REGRAS AQUI\n";
    menu += espacos + "REGRAS AQUI\n";
    menu += espacos + "              Pressione enter para continuar\n";
    return menu;
}

void fade_end_game(string head, string player) {
    string str = head;
    cout << str;
    so_sleep(0.1);
    for (int i = 0; i < player.size(); i++) {
        clear_screen();
        str += '?';
        cout << str << endl;
        so_sleep(0.1);
    }
    clear_screen();
    so_sleep(0.01);
    cout << head << player;
    so_sleep(1);
}

void end_menu(player &player1, player &player2) {
    clear_screen();
    string end_menu =  "===========================================================\n";
    string espacos = repeat(' ', (COLUNAS-end_menu.size())/2);
    end_menu = espacos + end_menu;
    end_menu += espacos + "--------------------- FIM DE JOGO -------------------------\n\n";
    end_menu += espacos + "~~~~~~~~~~~~~~~~~~ E O VENCEDOR FOI ~~~~~~~~~~~~~~~~~~~~~~~\n\n";
    end_menu += espacos;
    so_sleep(2);
    
    if (player1.points > player2.points) {
        fade_end_game(end_menu, player1.nickname);
        cout << endl << espacos << "PARABENS!!" << endl;
	} else if (player2.points > player1.points) {
	    fade_end_game(end_menu, player2.nickname);
        cout << endl << espacos << "PARABENS!!" << endl;
	} else {
        fade_end_game(end_menu, "EMPATE");
        cout << endl << espacos << "PARABENS! " << player1.nickname + ", " << player2.nickname << endl;
	}
}

void status_actual(player player1, player player2, int round_game, bool end_game) {
  string p1 = player1.nickname;
  string p2 = player2.nickname;
  int len = 6;
  if (p1.size() > len) {
    len = p1.size();
  }
  if (p2.size() > len) {
    len = p2.size();
  }
  string players = "Player";
  if (len != 6) {
    players += repeat(' ', len-6);
  }
  if (len != p1.size()) {
    p1 += repeat(' ', len-p1.size());
  }
  if (len != p2.size()) {
    p2 += repeat(' ', len-p2.size());
  }

  string spp1 = to_string ( player1.points );
  string spp2 = to_string ( player2.points );
  spp1 += repeat(' ', 6-spp1.size());
  spp2 += repeat(' ', 6-spp2.size());

  string divi = repeat('-', len+13) + "\n";
  string saida, head, espacos_head, espacos_line;
  if (end_game) {
    head = "================== RESUMO DA PARTIDA ======================\n";
    espacos_head = repeat(' ', (COLUNAS-head.size())/2);
    saida = "\n\n" + espacos_head + head;
  }
  else {
    head = "SITUACAO APOS A " + to_string( round_game ) + "ª RODADA\n";
    espacos_head = repeat(' ', (COLUNAS-head.size())/2);
    saida = espacos_head + head;
  }

  espacos_line = repeat(' ', (COLUNAS-divi.size())/2);
  saida += espacos_line + divi;
  saida += espacos_line + "| " + players + " | Pontos |\n";
  saida += espacos_line + divi;
  saida += espacos_line + "| " + p1 + " | " + spp1 + " |\n";
  saida += espacos_line + divi;
  saida += espacos_line + "| " + p2 + " | " + spp2 + " |\n";
  saida += espacos_line + divi;
  int cont = 10;

  if (end_game) {
    cout << saida;
  }
  else {
    while (cont > 0) {
      system("clear");
      cout << saida << endl << endl << repeat(' ', (COLUNAS-2)/2) << cont << endl;
      cont--;
      so_sleep(0.7);

    }
  }
}

/* Verifica se a letra esta na palavra,
 * e imprime a situacao da palavra no momento
*/
void verify_letter(player &gamer, char letter, level &actual_level, string actual_word, string &actual_status_of_word, bool penalize) {
	vector<int> index = contains(actual_word, letter);
	if (index.size() == 0) {
        cout << repeat(' ', (COLUNAS-CENTRALIZE)/2) << "A palavra nao possui essa letra!" << endl << endl;
        so_sleep(3);
        if (penalize) {
            penalize_player(actual_level, gamer);
        }
	}

	update_status_of_word(index, actual_status_of_word, letter);
}

void receive_letter(player &gamer, level &actual_level, string actual_word, string &actual_status_of_word, bool penalize){
    char letter;
    cout << endl << repeat(' ', (COLUNAS-CENTRALIZE)/2) << gamer.nickname + ", digite uma letra: ";
    cin >> letter;
    cout << endl;
	verify_letter(gamer, letter, actual_level, actual_word, actual_status_of_word, penalize);
}

void diplay_scoreboard(player p1, player p2) {
    string spaces_centralize = repeat(' ', (COLUNAS-CENTRALIZE)/2);
    
    string nickname1 = p1.nickname;
    string nickname2 = p2.nickname;
    if (nickname1.size() > nickname2.size()) {
        nickname2 += repeat(' ', nickname1.size() - nickname2.size());
    }
    else {
        nickname1 += repeat(' ', nickname2.size() - nickname1.size());
    }
    cout << spaces_centralize << nickname1 << " - Vidas: " << p1.lifes << endl;
    cout << spaces_centralize << nickname2 << " - Vidas: " << p2.lifes << endl << endl;
}

void display_round(string actual_status_of_word, player player1, player player2, level actual_level) {
  clear_screen();
  diplay_scoreboard(player1, player2);
  cout << repeat(' ', (COLUNAS-CENTRALIZE)/2) << "Nivel: " << actual_level.name << endl;
  string spaces_word = repeat(' ', (COLUNAS-actual_status_of_word.size())/2);
  cout << spaces_word << actual_status_of_word << endl << endl;

  string msg = "Digite uma letra ou codigo de bonus";
  string spaces_msg = repeat(' ', (COLUNAS-msg.size())/2);
  cout << spaces_msg << msg << endl;

  string spaces_bonus = repeat(' ', (COLUNAS-49)/2);
  string bonus_msg = spaces_bonus + "*************************************************\n";
  bonus_msg += spaces_bonus + "*                                               *\n";

  if (player1.choose_letter) {
      bonus_msg += spaces_bonus + "*  1. Escolher uma letra sem sofrer penalidade  *\n";
  }
  if (player1.type_word) {
      bonus_msg += spaces_bonus + "*  2. Solicitar o tipo da palavra               *\n";
  }
  if (player1.synonyms) {
      bonus_msg += spaces_bonus + "*  3. Solicitar palavra semelhante              *\n";
  }
  if (player1.syllables) {
      bonus_msg += spaces_bonus + "*  4. Pedir a quantidade de silabas da palavra  *\n";
  }
  bonus_msg += spaces_bonus + "*                                               *\n";
  bonus_msg += spaces_bonus + "*************************************************\n";

  cout << endl << bonus_msg << endl;
}

void menu(player &player1, player &player2, level &actual_level, string &actual_word, string &actual_status_of_word, word_data &actual_word_data) {
    display_round(actual_status_of_word, player1, player2, actual_level);

    char option;
    cout << repeat(' ', (COLUNAS-CENTRALIZE)/2) << player1.nickname << ": ";
    cin >> option;

    if (is_numeric(option)) {
        int bonus = to_int(option);

        // CONDICAO PARA O PRIMEIRO BONUS, POIS EXIGE QUE O USUARIO NAO SOFRA PENALIZACAO
        if (bonus < 0 || bonus > 4) {
           cout << "Opcao invalida!" << endl;
        }
        else if (bonus == 1 && player1.choose_letter) {
            receive_letter(player1, actual_level, actual_word, actual_status_of_word, false);
            cout << " ==> " << actual_status_of_word << endl << endl;
            set_bonus(player1, "choose_letter", false);
            display_round(actual_status_of_word, player1, player2, actual_level);
        } else {
            select_bonus(bonus, player1, actual_word, actual_word_data);
        }
        receive_letter(player1, actual_level, actual_word, actual_status_of_word, true);
        display_round(actual_status_of_word, player1, player2, actual_level);
    } else {
        verify_letter(player1, option, actual_level, actual_word, actual_status_of_word, true);
        display_round(actual_status_of_word, player1, player2, actual_level);
    }
}

void reset_words(string &actual_word, string &actual_status_of_word) {
    actual_word = "";
    actual_status_of_word = "";
}

void played(player &player1, player &player2, level &actual_level, string &actual_word, string &actual_status_of_word, int &covered_size, bool &state_game, int &round_game, bool &checked, word_data &actual_word_data) {
    menu(player1, player2, actual_level, actual_word, actual_status_of_word, actual_word_data);

    update_covered_size(covered_size, actual_word, actual_status_of_word);
    checked = complete_word(player1, actual_word, covered_size, actual_level);
    if (checked) {
        status_actual(player1, player2, round_game, false);
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

void set_dimensions(int &linhas, int &colunas) {
  struct winsize w;
  ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
  colunas = w.ws_col;
  linhas = w.ws_row;
}

int main() {
    clear_screen();
    set_dimensions(LINHAS, COLUNAS);
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
	cout << inicialize_menu();
    cin.ignore();
    clear_screen();

	// DADOS JOGADOR
	string head = "================== INICIANDO PARTIDA ======================\n";
    string espacos = repeat(' ', (COLUNAS - head.size())/2);
    cout << espacos << head;
	cout << espacos << "NOME JOGADOR 1: ";
	cin >> player1.nickname;
	cout << espacos << "NOME JOGADOR 2: ";
	cin >> player2.nickname;

    wait("PREPARANDO O AMBIENTE", 0.3);

	update_state_game(state_game, player1, player2);
	string line_data = get_line_data(actual_level);
  	word_data actual_word_data = get_word_data(line_data);
  	actual_word = selection_word(actual_word_data);
	model_word(actual_word.size(), actual_status_of_word);

	while (!state_game) {
        played(player1, player2, actual_level, actual_word, actual_status_of_word, covered_size, state_game, round_game, checked, actual_word_data);

        played(player2, player1, actual_level, actual_word, actual_status_of_word, covered_size, state_game, round_game, checked, actual_word_data);
	}
	end_menu(player1, player2);
	status_actual(player1, player2, round_game, true);
	return 0;
}

