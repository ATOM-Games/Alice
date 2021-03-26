constants
 separators=[' ',',','.',';','!','?']
domains
 clist=char*
 word=symbol
 str=symbol
 wordlist=symbol*
database
 manualWords(symbol)
 response(word,str)
 deadend(str)
 trouble(str)
 variety(word, wordlist)
predicates
 start
 createWorkspace
 chooseAct
 writeManual(integer)
 ex(integer)
 answer(integer)
 defanswer(integer)
 startChat
 startTrain
 chat
 stop(str)
 findKeyWord(wordlist)
 findVariety(word, wordlist)
 writeAnswer(str)
 addResponse
 delResponse
 editResponse
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

 chooseAct:-
        writeManual(0), answer(R).

 writeManual(0):-write("����� ����������!"), nl,
	    write("�������� ��������: "),nl,
		write("1 - �������"), nl,
		write("2 - ��������"), nl,
		write("3 - �����"), nl.

 writeManual(1):-
		write("Eliza: ������������. ���� ����� Eliza. � �� ������ ���������� � ���� � ���, � ��� ���������� ����� ������ �������. ������� ��, � �����. ��� �� ������ ������� ��� �������� ���� � �����? <���� - ����� ���������>"), nl, nl.
 writeManual(2):-nl, write("������ ��������� ��������?"), nl,
	    write("�������� ��������: "),nl,
		write("3 - �����"), nl,
		write("4 - ������� � ����"), nl,
		write("5 - ���������� �������"), nl.
 writeManual(3):-nl,
	    write("�������� ��������: "),nl,
		write("3 - �����"), nl,
		write("4 - ������� � ����"), nl,
		write("6 - �������� ������"), nl,
		write("7 - ������� ������"), nl,
		write("8 - �������� ������"), nl.
 writeManual(4):-
		write("������� �������� �����: "), nl.
 writeManual(5):-
		write("������� ������: "), nl.
 writeManual(6):-
		write("�������� �������!"), nl.
 writeManual(7):-
		write("�� ������ �������: "), nl.
 writeManual(8):-
		write("1 - ��"), nl,
		write("2 - ���, ��� ������"), nl,
		write("3 - ������"), nl.
 writeManual(9):-
		write("������ �� ������ ����� �� ������. "), nl.
 writeManual(10):-
		write("�������� �������� "), nl.
 writeManual(11):-
		write("�� ������ ��������: "), nl.
 writeManual(12):-
		write("��� �� ������ ��������: "), nl,
		write("1. - �������� �����"), nl,
		write("2. - ������"), nl,
		write("3. - ������"), nl.
 writeManual(13):-
		write("������� ����� ������: "), nl.

 ex(3):-exit.
 ex(4):-retractAll(_), clearwindow(), shiftwindow(1), chooseAct,!.
 ex(5):-consult("dbstart.ddb"), chat,!.
 ex(6):-addResponse.
 ex(7):-delResponse.
 ex(8):-editResponse.
 ex(_).

 stop("����"):-writeManual(2), readint(R), ex(R), !.
 stop(_).

 answer(R):-write("�� ������� "), defAnswer(R).

 defAnswer(1):-write("�������"),nl,nl, startChat.
 defAnswer(2):-write("��������"),nl,nl, startTrain.

 startChat:-
		writeManual(1),
		retractAll(_), consult("dbmember.ddb"),
		consult("dbstart.ddb"), chat.

 chat:-	write("��: "),
		readln(S), stop(S), str_list(S,L), rem_empty(L,L1),
		findKeyWord(L).

 findKeyWord([]):-
                trouble(S), nl, write("Eliza: ",S), nl, nl,
                retract(trouble(S)), chat, !.
 findKeyWord([]):-writeManual(2), readint(R), ex(R), !.
 findKeyWord([]).
 findKeyWord([H|T]):-
		variety(W,L), findVariety(H,L), response(W,R),
		retract(response(W,R)), writeAnswer(R); findKeyWord(T).
		%response(H,R), retract(response(H,R)),
		%writeAnswer(R); findKeyWord(T).

 %findVariety(_,[]).
 findVariety(H,[H|T]):-!.
 findVariety(W,[H|T]):-findVariety(W,T).

 writeAnswer(R):-nl, write("Eliza: ",R), nl, nl, chat.

 startTrain:-writeManual(3), readint(R), ex(R),!.

 addResponse:-
		writeManual(4), readln(S), first_word(S,W,_),
		writeManual(5), readln(R),
		retractAll(_),
	    consult("dbMember.ddb"),
	    assertz(response(W,R)),
		assertz(variety(W,[W])),
	    save("dbMember.ddb"),
		retractAll(_),
		retractAll(_), !,
	    writeManual(6), startTrain.

 delResponse:-
		writeManual(4), readln(S), first_word(S,W,_),
		consult("dbMember.ddb"), confirmDel(W); writeManual(9), nl, startTrain.

 confirmDel(W):- response(W,R),
		writeManual(7), printPredicate(W,R),
		writeManual(8), readint(A), delAnswer(A,W,R),
		nl, startTrain.

 delAnswer(1,W,R):-
                retractAll(_), consult("dbMember.ddb"),
                retract(response(W,R)), save("dbMember.ddb"),
                writeManual(6).
 delAnswer(2,W,R):-
                retract(response(W,R)), confirmDel(W).
 delAnswer(3,_,_):-writeManual(10).

 printPredicate(W,R):-write("response('",W,"','",R,"') ?"), nl.

 editResponse:-writeManual(4), readln(S), first_word(S,W,_),
		consult("dbMember.ddb"), confirmEdit(W); writeManual(9), nl, startTrain.

 confirmEdit(W):-response(W,R),
		writeManual(11), printPredicate(W,R),
		writeManual(8), readint(A), editAnswer(A,W,R),
		nl, startTrain.

 editAnswer(1,W,R):-
                writeManual(12), readint(A),
				toEdit(A,W,R), writeManual(6).
 editAnswer(2,W,R):-
                retract(response(W,R)), confirmEdit(W).
 editAnswer(3,_,_):-writeManual(10).

 toEdit(1,W,R):-writeManual(4), readln(S), first_word(S,W1,_),
				retractAll(_), consult("dbMember.ddb"),
                retract(response(W,R)), assert(response(W1,R)),
				save("dbMember.ddb").
 toEdit(2,W,R):-writeManual(13), readln(S),
				retractAll(_), consult("dbMember.ddb"),
                retract(response(W,R)), assert(response(W,S)),
				save("dbMember.ddb").
 toEdit(3,_,_):-writeManual(10).

 lower_rus(C,C1):-
  '�'<=C, C<='�', !, char_int(C,I),
  I1=I+(160-128), char_int(C1,I1).
 lower_rus(C,C1):-
  '�'<=C, C<='�',!, char_int(C,I),
  I1=I+(224-144), char_int(C1,I1).
 lower_rus(C,C).

 first_word("","",""):-!.
 first_word(S,W,R):-
  frontchar(S,C,R1), not(member(C,separators)),
  !, first_word(R1,S1,R), lower_rus(C,C1), frontchar(W,C1,S1).
 first_word(S,"",R):-frontchar(S,_,R).

 member(X,[X|_]):-!.
 member(X,[_|S]):-member(X,S).

 del_sep("",""):-!.
 del_sep(S,S1):-
  frontchar(S,C,R), member(C,separators),
  !, del_sep(R,S1).
 del_sep(S,S).

 str_list("",[]):-!.
 str_list(S,[H|T]):-
  first_word(S,H,R), !, str_list(R,T).

 rem_empty([],[]).
 rem_empty([""|T],T1):-rem_empty(T,T1).
 rem_empty([H|T],[H|T1]):-H<>"", rem_empty(T,T1).
goal
 start.
