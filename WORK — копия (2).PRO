constants
 separators=[' ',',','.',';','!','?']
domains
 clist=char*
 word=symbol
 str=symbol
 wordlist=symbol*
database
 manualWords(symbol)
 react(word,str) 
 deadend(str)
 trouble(str)
 keywordvar(word, wordlist)
 kontext(word, word, wordlist)
 global_kontext(word)

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
 stop(str)
 findKeyWord(wordlist,wordlist)
 findKeyKont(word, wordlist)
 findkeywordvar(word, wordlist)
 findkontext(word, wordlist)
 writeAnswer(str)
 addReact
 delReact
 editReact
 confirmDel(word)
 printPredicate(word, str)
 delAnswer(integer, word, str)
 confirmEdit(word)
 toEdit(integer, word, str)
 editAnswer(integer, word, str)
 lower_rus(char, char)
 first_word(str, word, str)
 member(char, clist)
 del_sep(str,str)
 str_list(str, wordlist)
 rem_empty(wordlist,wordlist)
clauses
 start:- createWindows, activateProgramm.
		
 createWindows:-
		makewindow(1,10,10,"MAIN MENU",1,0,10,35),
		makewindow(2,3,3,"CHATING",1,35,23,45),
		makewindow(3,2,2,"TRAINING",11,0,13,35),
		shiftwindow(1).
		
 activateProgramm:- writeMenu(0), readint(R), ex_it(R), N=R+1, 
		clearwindow(), shiftwindow(N), answer(R).
 
 writeMenu(0):- write("���� ���������� �� ������� ����!"), nl,
	    write("�롥�� ����⢨�: "),nl,
		write("1 - ��饭��"), nl, 
		write("2 - ���祭��"), nl,
		write("3 - ��室"), nl.
		
 writeMenu(1):- write("Eliza: ��ࠢ����. ���� ����� Eliza. � �� �⥫� ��������� � ���� � ⮬, �� ����� ����� �� ��� ��� �� ࠧ � �����. ����筮 ��, � ��ᬮ�� 䨫쬮� � � 䨫쬠� � 楫��. �� ��� ����� ���ࠢ����� � ��襬 䨫쬥? <�⮯ - �⮡� ��������>"), nl, nl.
 writeMenu(2):- nl, write("���� �������� ࠧ�����?"), nl,
	    write("�롥�� ����⢨�: "),nl,
		write("3 - ��室"), nl, 
		write("4 - ������ � ����"), nl,
		write("5 - �த������ ��饭��"), nl.
 writeMenu(3):- nl, 
	    write("�롥�� ����⢨�: "),nl,
		write("3 - ��室"), nl, 
		write("4 - ������ � ����"), nl,
		write("6 - �������� �⪫��"), nl,
		write("7 - 㤠���� �⪫��"), nl,
		write("8 - �������� �⪫��"), nl.
 writeMenu(4):- write("������ ���祢�� ᫮��: "), nl.
 writeMenu(5):- write("������ �⪫��: "), nl.
 writeMenu(6):- write("������ �ᯥ譠!"), nl.
 writeMenu(7):- write("�� ��� 㤠����: "), nl.
 writeMenu(8):-
		write("1 - ��"), nl,
		write("2 - ���, �� ��㣮�"), nl,
		write("3 - �⬥��"), nl.
 writeMenu(9):- write("�⪫�� �� ������ ᫮�� �� ������. "), nl.
 writeMenu(10):- write("������ �⬥���� "), nl.
 writeMenu(11):- write("�� ��� ��������: "), nl.
 writeMenu(12):-
		write("�� �� ��� ��������: "), nl,
		write("1. - ���祢�� ᫮��"), nl,
		write("2. - �⪫��"), nl,
		write("3. - �⬥��"), nl.
 writeMenu(13):- write("������ ���� �⪫��: "), nl.
		
 ex_it(3):-exit.
 ex_it(4):-retractAll(_), clearwindow(), shiftwindow(1), activateProgramm,!.
 ex_it(5):-consult("dbstart.ddb"), chat,!.
 ex_it(6):-addReact.
 ex_it(7):-delReact.
 ex_it(8):-editReact.
 ex_it(_).
 
 stop("�⮯"):- writeMenu(2), readint(R), ex_it(R), !.
 stop(_).
 
 answer(R):-write("�� ��ࠫ� "), defAnswer(R).
	
 defAnswer(1):- write("��饭��"),nl,nl, startChat.
 defAnswer(2):- write("���祭��"),nl,nl, startLearn.
 
 startChat:- writeMenu(1), 
		retractAll(_), consult("dbmember.ddb"), 
		consult("dbstart.ddb"), chat.
		
 chat:-	write("��: "),
		readln(S), stop(S), str_list(S,L), rem_empty(L,L1),
		findKeyWord(L,L).
		
 findKeyWord([],_):- trouble(S), nl, write("Eliza: ",S), nl, nl, retract(trouble(S)), chat, !.
 findKeyWord([],_):- writeMenu(2), readint(R), ex_it(R), !.				

 findKeyWord([],[]).		
 findKeyWord([H|T],P):- keywordvar(K,L), findkeywordvar(H,L), findKeyKont(K,P); findKeyWord(T,P).
 
 findKeyKont(K,[]):- react(K,R), retract(react(K,R)), writeAnswer(R); findKeyWord([],[]), !.
 findKeyKont(K,[]). 
 findKeyKont(K,[H|T]):- kontext(W,K,L), findkontext(H,L), react(W,R),
		retract(react(W,R)), writeAnswer(R); findKeyKont(K,T).
 
 findkeywordvar(H,[H|T]):-!.
 findkeywordvar(W,[H|T]):- findkeywordvar(W,T). 
 
 findkontext(H,[H|T]):-!.
 findkontext(W,[H|T]):- findkontext(W,T). 
		
 writeAnswer(R):- nl, write("Eliza: ",R), nl, nl, chat.		
		
 startLearn:- writeMenu(3), readint(R), ex_it(R),!.
 
 addReact:- writeMenu(4), readln(S), first_word(S,W,_),str_list(S,Q),write(Q),
		writeMenu(5), readln(R),
		retractAll(_),
	    consult("dbmember.ddb"),
	    assertz(react(W,R)), 
		assertz(keywordvar(W,Q)),
	    save("dbmember.ddb"), 
		retractAll(_),
		retractAll(_), !,
	    writeMenu(6), startLearn.
 
 delReact:- writeMenu(4), readln(S), first_word(S,W,_), 
		consult("dbmember.ddb"), confirmDel(W); writeMenu(9), nl, startLearn.

 confirmDel(W):- react(W,R), writeMenu(7), printPredicate(W,R), 
		writeMenu(8), readint(A), delAnswer(A,W,R),
		nl, startLearn.
		
 delAnswer(1,W,R):- retractAll(_), consult("dbmember.ddb"), 
                retract(react(W,R)), save("dbmember.ddb"),
                writeMenu(6).
 delAnswer(2,W,R):- retract(react(W,R)), confirmDel(W).
 delAnswer(3,_,_):- writeMenu(10).
 
 printPredicate(W,R):- write("react('",W,"','",R,"') ?"), nl.
 
 editReact:- writeMenu(4), readln(S), first_word(S,W,_), 
		consult("dbmember.ddb"), confirmEdit(W); writeMenu(9), nl, startLearn.
		
 confirmEdit(W):-react(W,R), writeMenu(11), printPredicate(W,R), 
		writeMenu(8), readint(A), editAnswer(A,W,R), nl, startLearn.
		
 editAnswer(1,W,R):- writeMenu(12), readint(A), toEdit(A,W,R), writeMenu(6).
 editAnswer(2,W,R):- retract(react(W,R)), confirmEdit(W).
 editAnswer(3,_,_):- writeMenu(10).
 
 toEdit(1,W,R):-writeMenu(4), readln(S), first_word(S,W1,_),
				retractAll(_), consult("dbmember.ddb"), 
                retract(react(W,R)), assert(react(W1,R)),
				save("dbmember.ddb").
 toEdit(2,W,R):-writeMenu(13), readln(S), 
				retractAll(_), consult("dbmember.ddb"), 
                retract(react(W,R)), assert(react(W,S)),
				save("dbmember.ddb").
 toEdit(3,_,_):-writeMenu(10).
		
 lower_rus(C,C1):- '�'<=C, C<='�', !, char_int(C,I), I1=I+(160-128), char_int(C1,I1).
 lower_rus(C,C1):- '�'<=C, C<='�',!, char_int(C,I), I1=I+(224-144), char_int(C1,I1).
 lower_rus(C,C).
 
 first_word("","",""):-!.
 first_word(S,W,R):- frontchar(S,C,R1), not(member(C,separators)), !,
		first_word(R1,S1,R), lower_rus(C,C1), frontchar(W,C1,S1).
 first_word(S,"",R):-frontchar(S,_,R).
 
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