% Comp304 assignment 4
% Tim Williams ID 300296562
% Dr Roberts, the incompetent psychiatrist

% printSentence/1, takes a list of atoms.
% It if the Head element is 'qm' it prints ?
% otherwise it goes on to print the Head to a whitespace
% then recureses on the Tail

printSentence([Head|Tail]) :-
            Head == 'qm' -> write('?');
            write(Head), write(' '), 
            printSentence(Tail).

% printSentence on empty list prints a new line

printSentence([]) :- nl.

% asnwer/2 has two parameters -  the question asked by user, and the reply by Dr Roberts
% First it calls on transform predicate to check for known patterns in the list and get a
% transformed list back, if not match is found it returns the original list.
% 
% then calls match to with the transormed list to check for individual words that need to
% be swapped
% 
% after this 'qm' is appended, to add a question mark to the reply.
% then calls printSentence with the reply

answer(Question, Output) :-
    transform(Question, Response),
    match(Response, Output),
    append(Output,[qm],Reply),
    printSentence(Reply),
    !. % stop after printing first reply

% transform/2 checks for patterns in the input list, if a match is found it replaces that part
% with a predefined list of atoms and puts it at the head of the list.
% This implementation only accounts for matches at the start and it can't really append to the end.
% I know this is not ideal. This is why I need to append 'qm' in answer/2

transform([i,know | X], [are,you,sure,you,know,that |X]).
transform([i,am | X], [why,are,you | X]).
transform([i,feel | X], [what,makes,you,feel | X]).
transform([i | X], [have,you,ever | X]).
transform([sometimes,i | X], [how,often,do,you | X]).
transform([sometimes | X], [how,often,does | X]).

% if nothing was picked up to translate, repeat the question back
transform(X,X).

% match/2 takes a list and calls swap on the head to check for word matches
% NewH replaces H as the head of the list, then continues recursively on the
% rest of the list

match([],[]).
%match(
match([H|T],[NewH|NewT]) :-
    swap(H, NewH),
    match(T,NewT).

% swap predicate searches for certain individual words to translate, it is a helper
% for match

swap(me, you) :- !.
swap(i, you) :- !.
swap(my, your) :- !.
swap(mine, yours) :- !.
swap(am, are) :- !.
swap(talks, talk) :- !.

% if no match found, do not change
swap(X, X).

% print reply
% user calls this predicate with a list of atoms, then printReply
% calls answer predicate with the question and 'Response', in which
% answer stores the reply
printReply(Question) :-
    answer(Question,Response).

% test inputs
%               INPUT                                                       OUTPUT
% printReply([i,fantasised,about,fat,cats]).                have you ever fantasised about fat cats ?   %this is an instance that shows my program 
%                                                                                                       % being a bit brokem, can't print 'before' at the end
% 
% printReply([i,feel,like,my,mother,wants,to,poison,me]).   what makes you feel like your mother wants to poison you ?
% 
% printReply([i,feel,as,if,my,brain,is,not,really,mine]).   what makes you feel as if your brain is not really yours ?
% 
% printReply([i,feel,bad,about,my,brother]).                what makes you feel bad about your brother ?
% 
% printReply([i,am,sure,my,dog,is,a,ghost]).                why are you sure your dog is a ghost ?
% 
% printReply([i,know,i,am,inseucre]).                       are you sure you know that you are inseucre ?
% 
% printReply([i,know,my,dog,is,satan]).                     are you sure you know that your dog is satan ?
% 
% printReply([sometimes,i,steal,my,cats,food]).             how often do you steal your cats food ?
% 
% printReply([sometimes,my,cat,talks,to,me,about,arson])    how often does your cat talk to you about arson ?
