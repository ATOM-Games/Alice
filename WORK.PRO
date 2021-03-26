code=2000
constants
 separators=[' ',',','.',';','!','?']
 dontknow=["не знаю","Не знаю","Понятия не имею","Без понятия","Ума не приложу"]
 beforeName=["А я слышала, что","А мне говорили, что","А я недавно узнала, что","А я узнала, что","А мне сказали, что"]
 postName=["Что, на ваш взгляд, общего в его фильмах?","О чем в основном его фильмы?"]
domains
 clist=char*
 word=symbol
 str=symbol
 wordlist=symbol*
 strlist=str*
database
 manualWords(symbol)
 react(word,word,str,word) 
 deadend(str)
 trouble(str)
 keywordvar(word,word,wordlist,word)
 kontext(word,word,word,wordlist,word)
 global_kontext(word)
 bN(integer)
 pN(integer)
 name(symbol,wordlist)
 fam(symbol,wordlist)
 man(symbol,symbol,symbol)
predicates
 start
 createWindows
 activateProgramm
 writeMenu(integer)
 ex_it(integer)
 answer(integer)
 defanswer(integer)
 startChat
 startLearn
 chat
 learn_chat_man(word,word,wordlist)
 stop(str)
 tema(str)
 findKeyWord(wordlist,wordlist)
 findName(wordlist,wordlist)
 findFam(wordlist,wordlist,word)
 findKeyKont(word,wordlist,word)
 findkeywordvar(word,wordlist)
 findkontext(word,wordlist)
 getBeforIndex(strlist,integer,integer,str)
 getPostIndex(strlist,integer,integer,str)
 writeAnswer(str)
 addReact
 delReact
 editReact
 addnameofpeople
 addfamofpeople
 confirmDel(word)
 printPredicate(word,str)
 delAnswer(integer,word,str)
 confirmEdit(word)
 toEdit(integer,word,str)
 editAnswer(integer, word, str)
 lower_rus(char, char)
 first_word(str, word, str)
 first_word_not_lower(str, word, str)
 member(char, clist)
 del_sep(str,str)
 str_list(str, wordlist)
 rem_empty(wordlist,wordlist)
clauses
 start:- createWindows, activateProgramm.
		
 createWindows:-
		makewindow(1,10,10,"Главное меню",1,0,10,35),
		makewindow(2,3,3,"Чат",1,35,23,45),
		makewindow(3,2,2,"Обучение",11,0,13,35),
		shiftwindow(1).
		
 activateProgramm:- writeMenu(0), readint(R), ex_it(R), N=R+1, 
		clearwindow(), shiftwindow(N), answer(R).
 
 writeMenu(0):- write("Добро пожаловать на главное меню!"), nl,
	    write("Выберите действие: "),nl,
		write("1 - общение"), nl, 
		write("2 - обучение"), nl,
		write("3 - выход"), nl.
		
 writeMenu(1):- write("Eliza: Здравствуйте. Меня зовут Eliza. Я бы хотела поговорить с вами о том, что делал каждый из нас хотя бы раз в жизни. Конечно же, о просмотре фильмов и о фильмах в целом. Что вам может понравиться в хорошем фильме? <Стоп - чтобы закончить>"),
		assertz(global_kontext("понравиться")),nl,assertz(bN(0)),assertz(pN(0)), nl.
 writeMenu(2):- nl, write("Хотите завершить разговор?"), nl,
	    write("Выберите действие: "),nl,
		write("3 - выход"), nl, 
		write("4 - возврат к меню"), nl,
		write("5 - продолжить общение"), nl.
 writeMenu(3):- nl, 
	    write("Выберите действие: "),nl,
		write("3 - выход"), nl, 
		write("4 - возврат к меню"), nl,
		write("6 - добавить отклик"), nl,
		write("7 - удалить отклик"), nl,
		write("8 - изменить отклик"), nl,
		write("9 - добавить имя"), nl,
		write("10 - добавить фамилию"), nl.
 writeMenu(4):- write("Введите ключевое слово: "), nl.
 writeMenu(5):- write("Введите отклик: "), nl.
 writeMenu(6):- write("Операция успешна!"), nl.
 writeMenu(7):- write("Вы хотите удалить: "), nl.
 writeMenu(8):-
		write("1 - Да"), nl,
		write("2 - Нет, ищи другой"), nl,
		write("3 - Отмена"), nl.
 writeMenu(9):- write("Отклик на данное слово не найден. "), nl.
 writeMenu(10):- write("Операция отменена "), nl.
 writeMenu(11):- write("Вы хотите изменить: "), nl.
 writeMenu(12):-
		write("Что вы хотите изменить: "), nl,
		write("1. - ключевое слово"), nl,
		write("2. - отклик"), nl,
		write("3. - отмена"), nl.
 writeMenu(13):- write("Введите новый отклик: "), nl.
		
 ex_it(3):-exit.
 ex_it(4):-retractAll(_), clearwindow(), shiftwindow(1), activateProgramm,!.
 ex_it(5):-consult("dbstart.ddb"), chat,!.
 ex_it(6):-addReact.
 ex_it(7):-delReact.
 ex_it(8):-editReact.
 ex_it(9):-addnameofpeople.
 ex_it(10):-addfamofpeople.
 ex_it(_).
 
 tema("Тема"):- global_kontext(T), write(T),writeMenu(2), readint(R), ex_it(R),!.
 tema(_).

 stop("Элиза, пока!"):- write("Eliza: Вы уже уходите? "),nl,
		write("4 - Извини, да, мне пора"), nl,
		write("5 - Извини, нет, я ошибся"), nl,
		readint(R), not(R=5),nl, write("Eliza: Ну, тогда до свидания!"),ex_it(4),!; ex_it(5),!.
 stop("Стоп"):- writeMenu(2), readint(R), ex_it(R),!.
 stop(_).
 
 answer(R):-write("Вы выбрали "), defAnswer(R).
	
 defAnswer(1):- write("общение"),nl,nl, startChat.
 defAnswer(2):- write("обучение"),nl,nl, startLearn.
 
 startChat:- retractAll(_), consult("dbmember.ddb"),
		consult("dbstart.ddb"),writeMenu(1),chat.
		
 chat:-	write("Вы: "),
		readln(S), stop(S), tema(S), str_list(S,L), rem_empty(L,_),findName(L,L),
		findKeyWord(L,L).
		
 findKeyWord([],_):- trouble(S), nl, write("Eliza: ",S), nl, nl, retract(trouble(S)), chat, !.
 findKeyWord([],_):- writeMenu(2), readint(R), ex_it(R), !.				

 findKeyWord([],[]).		
 findKeyWord([H|_],P):- global_kontext(Gk), keywordvar(Gk,K,L,NewG),findkeywordvar(H,L),
						retract(global_kontext(Gk)),assertz(global_kontext(NewG)),findKeyKont(K,P,NewG).
 findKeyWord([H|_],P):- keywordvar(_,K,L,NewG),findkeywordvar(H,L),
						assertz(global_kontext(NewG)),findKeyKont(K,P,"-").
 findKeyWord([_|T],P):- findKeyWord(T,P).
 
 findKeyKont(K,[],Gk):- react(Gk,K,R,NewGk),retract(react(Gk,K,R,NewGk)),
					writeAnswer(R),retract(global_kontext(Gk)),assertz(global_kontext(NewGk));
					react(_,K,R,NewGk),retract(react(_,K,R,NewGk)),
					writeAnswer(R),assertz(global_kontext(NewGk));
					findKeyWord([],[]), !.
 findKeyKont(_,[],_). 
 findKeyKont(K,[H|_],Gk):- kontext(Gk,W,K,L,NGk), findkontext(H,L), react(Gk,W,R,NewGk),
						retract(react(Gk,W,R,NewGk)),retract(global_kontext(Gk)),assertz(global_kontext(Gk)), writeAnswer(R);
						kontext(_,W,K,L,NGk), findkontext(H,L), react(_,W,R,NewGk),
						retract(react(_,W,R,NewGk)),assertz(global_kontext(Gk)), writeAnswer(R).
 findKeyKont(K,[_|T],Gk):- findKeyKont(K,T,Gk).
 
 findkeywordvar(H,[H|_]):-!.
 findkeywordvar(W,[_|T]):- findkeywordvar(W,T). 
 
 findkontext(H,[H|_]):-!.
 findkontext(W,[_|T]):- findkontext(W,T). 
		
 writeAnswer(R):- nl, write("Eliza: ",R), nl, nl, chat.		

 findName([],_).
 findName([],[]).
 findName([H|_],P):- name(N,A),findkeywordvar(H,A),findFam(P,P,N).
 findName([_|T],P):- findName(T,P).

 findFam([],_,_):- findName([],[]).
 findFam([H|_],_,N):-fam(F,A),findkeywordvar(H,A),man(N,F,D),bN(Bn),pN(Pn),
		getBeforIndex(beforeName,Bn,Bn,Bb),getPostIndex(postName,Pn,Pn,Pp),
		nl,write("Eliza: ",Bb," ",N," ",F," - ",D," ",Pp),nl,nl,chat.
 findFam([H|_],P,N):-fam(F,A),findkeywordvar(H,A),not(man(N,F,_)),
		nl,write("Eliza: А кто такой ",N," ",F,"?"),nl,nl,learn_chat_man(N,F,P).
 findFam([_|T],P,N):-findFam(T,P,N).
  
 learn_chat_man(N,F,P):- write("Вы: "), readln(D),not(D="не знаю"),
	first_word(D,_,W),retractAll(_), retractAll(_), !, 
	consult("dbstart.ddb"), assertz(man(N,F,W)), save("dbstart.ddb"), 
	retractAll(_), consult("dbmember.ddb"),
	consult("dbstart.ddb"),nl, write("Eliza: Спасибо, что сказали, постараюсь запомнить"),findKeyWord(P,P);
	nl,write("Eliza: Ничего страшного, продолжим разговор"),findKeyWord(P,P). 
 
 startLearn:- writeMenu(3), readint(R), ex_it(R),!.
 
 addReact:- writeMenu(4), readln(S), first_word(S,W,_),str_list(S,Q),
		writeMenu(5), readln(R),
		retractAll(_),
	    consult("dbmember.ddb"),
		write("В каком контексте : "),nl,readln(OldGk),
		write("Переводит на тему : "),nl,readln(NewGk),
	    assertz(react(OldGk,W,R,OldGk)), 
		assertz(keywordvar(OldGk,W,Q,NewGk)),
	    save("dbmember.ddb"), 
		retractAll(_),
		retractAll(_), !,
	    writeMenu(6), startLearn.
 
 delReact:- writeMenu(4), readln(S), first_word(S,W,_), 
		consult("dbmember.ddb"), confirmDel(W); writeMenu(9), nl, startLearn.

 confirmDel(W):- react(_,W,R,_), writeMenu(7), printPredicate(W,R), 
		writeMenu(8), readint(A), delAnswer(A,W,R),
		nl, startLearn.
		
 delAnswer(1,W,R):- retractAll(_), consult("dbmember.ddb"), 
                retract(react(_,W,R,_)), save("dbmember.ddb"),
                writeMenu(6).
 delAnswer(2,W,R):- retract(react(_,W,R,_)), confirmDel(W).
 delAnswer(3,_,_):- writeMenu(10).
 
 printPredicate(W,R):- write("react('",W,"','",R,"') ?"), nl.
 
 editReact:- writeMenu(4), readln(S), first_word(S,W,_), 
		consult("dbmember.ddb"), confirmEdit(W); writeMenu(9), nl, startLearn.
		
 confirmEdit(W):-react(_,W,R,_), writeMenu(11), printPredicate(W,R), 
		writeMenu(8), readint(A), editAnswer(A,W,R), nl, startLearn.
		
 editAnswer(1,W,R):- writeMenu(12), readint(A), toEdit(A,W,R), writeMenu(6).
 editAnswer(2,W,R):- retract(react(_,W,R,_)), confirmEdit(W).
 editAnswer(3,_,_):- writeMenu(10).
 
 toEdit(1,W,R):-writeMenu(4), readln(S), first_word(S,W1,_),
				write("Новый входящий контекст : "),readln(OldGk), first_word(OldGk,WoldK,_),
				write("Новый исходящий контекст : "),readln(NewGk), first_word(NewGk,WnewK,_),
				retractAll(_), consult("dbmember.ddb"), 
                retract(react(_,W,R,_)), assert(react(WoldK,W1,R,WnewK)),
				save("dbmember.ddb").
 toEdit(2,W,R):-writeMenu(13), readln(S), 
				retractAll(_), consult("dbmember.ddb"), 
				write("Новый входящий контекст : "),readln(OldGk), first_word(OldGk,WoldK,_),
				write("Новый исходящий контекст : "),readln(NewGk), first_word(NewGk,WnewK,_),
                retract(react(_,W,R,_)), assert(react(WoldK,W,S,WnewK)),
				save("dbmember.ddb").
 toEdit(3,_,_):-writeMenu(10).
		
 lower_rus(C,C1):- 'А'<=C, C<='П', !, char_int(C,I), I1=I+(160-128), char_int(C1,I1).
 lower_rus(C,C1):- 'Р'<=C, C<='Я', !, char_int(C,I), I1=I+(224-144), char_int(C1,I1).
 lower_rus(C,C).
 
 first_word("","",""):-!.
 first_word(S,W,R):- frontchar(S,C,R1), not(member(C,separators)), !,
		first_word(R1,S1,R), lower_rus(C,C1), frontchar(W,C1,S1).
 first_word(S,"",R):-frontchar(S,_,R).
 
 first_word_not_lower("","",""):-!.
 first_word_not_lower(S,W,R):- frontchar(S,C,R1), not(member(C,separators)), !,
		first_word_not_lower(R1,S1,R), frontchar(W,C,S1).
 first_word_not_lower(S,"",R):-frontchar(S,_,R).
 
 getBeforIndex([H],_,C,H):- C>0,retract(bN(_)),assertz(bN(0)),!.
 getBeforIndex([H|_],0,C,H):-retract(bN(_)),C1=C+1,assertz(bN(C1)),!.
 getBeforIndex([_|T],N,C,W):- N1=N-1,getBeforIndex(T,N1,C,W).
 
 getPostIndex([H],_,C,H):- C>0,retract(pN(_)),assertz(pN(0)),!.
 getPostIndex([H|_],0,C,H):-retract(pN(_)),C1=C+1,assertz(pN(C1)),!.
 getPostIndex([_|T],N,C,W):- N1=N-1,getPostIndex(T,N1,C,W).
 
 
 addnameofpeople:- write("Введите имя : "), readln(S), first_word_not_lower(S,W,_),str_list(S,Q),
	    retractAll(_), retractAll(_), !,
		consult("dbstart.ddb"), assertz(name(W,Q)), save("dbstart.ddb"), 
		retractAll(_), retractAll(_), !,
	    writeMenu(6), startLearn.
 addfamofpeople:- write("Введите фамилию : "), readln(S), first_word_not_lower(S,W,_),str_list(S,Q),
	    retractAll(_), retractAll(_), !,
		consult("dbstart.ddb"), assertz(fam(W,Q)), save("dbstart.ddb"), 
		retractAll(_), retractAll(_), !,
	    writeMenu(6), startLearn.
 
 member(X,[X|_]):-!.
 member(X,[_|S]):-member(X,S).
 
 del_sep("",""):-!.
 del_sep(S,S1):- frontchar(S,C,R), member(C,separators), !, del_sep(R,S1).
 del_sep(S,S).
 
 str_list("",[]):-!.
 str_list(S,[H|T]):-first_word(S,H,R), !, str_list(R,T).
 
 rem_empty([],[]).
 rem_empty([""|T],T1):-rem_empty(T,T1).
 rem_empty([H|T],[H|T1]):-H<>"", rem_empty(T,T1).
goal
 start.